import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

enum PaymentMethod { cash, bankTransfer, card }

enum PaymentStatus { pending, processing, successful, failed, canceled }

class PaymentResult {
  final PaymentStatus status;
  final String reference;
  final String message;
  final String? checkoutUrl;

  const PaymentResult({
    required this.status,
    required this.reference,
    required this.message,
    this.checkoutUrl,
  });

  bool get isSuccessful => status == PaymentStatus.successful;
}

abstract class PaymentGateway {
  Future<PaymentResult> initialize({
    required double amount,
    required String currency,
    required String email,
    required String reference,
    required String bookingId,
  });
}

/// Simulated gateway used when Firebase/Cloud Functions are unavailable.
/// Always succeeds after a short delay so the UI flow can be exercised.
class MockPaymentGateway implements PaymentGateway {
  @override
  Future<PaymentResult> initialize({
    required double amount,
    required String currency,
    required String email,
    required String reference,
    required String bookingId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    return PaymentResult(
      status: PaymentStatus.successful,
      reference: reference,
      message:
          'Payment of ${amount.toStringAsFixed(2)} $currency approved (demo).',
    );
  }
}

/// Production gateway seam. Calls a Cloud Function named `initializePayment`
/// which must hold the Paystack secret key and return `authorizationUrl` plus
/// `reference`. Never ship a payment secret key in the Flutter app.
class PaystackCloudGateway implements PaymentGateway {
  final FirebaseFunctions _functions;

  PaystackCloudGateway({FirebaseFunctions? functions})
    : _functions = functions ?? FirebaseFunctions.instance;

  @override
  Future<PaymentResult> initialize({
    required double amount,
    required String currency,
    required String email,
    required String reference,
    required String bookingId,
  }) async {
    final callable = _functions.httpsCallable('initializePayment');
    final response = await callable.call(<String, dynamic>{
      'amount': amount,
      'currency': currency,
      'email': email,
      'reference': reference,
      'bookingId': bookingId,
    });

    final data = Map<String, dynamic>.from(response.data as Map);
    return PaymentResult(
      status: PaymentStatus.processing,
      reference: data['reference'] as String? ?? reference,
      message: 'Complete checkout in the secure payment window.',
      checkoutUrl: data['authorizationUrl'] as String?,
    );
  }
}

/// Handles payment initiation and writes an auditable transaction record.
class PaymentService {
  static final PaymentService _instance = PaymentService._internal();
  factory PaymentService() => _instance;
  PaymentService._internal();

  PaymentGateway? _gateway;
  FirebaseFirestore? _firestoreInstance;

  FirebaseFirestore get _firestore =>
      _firestoreInstance ??= FirebaseFirestore.instance;

  bool get _firebaseReady => Firebase.apps.isNotEmpty;

  PaymentGateway get gateway => _gateway ??= _firebaseReady
      ? PaystackCloudGateway()
      : MockPaymentGateway();

  set gateway(PaymentGateway value) => _gateway = value;

  String _newReference() =>
      'SS-${DateTime.now().millisecondsSinceEpoch}-${DateTime.now().microsecond % 1000}';

  Future<PaymentResult> pay({
    required double amount,
    required PaymentMethod method,
    required String email,
    String currency = 'NGN',
    String bookingId = '',
  }) async {
    final reference = _newReference();

    // Cash is settled on completion and bank transfers are reconciled later,
    // so neither needs a card gateway round-trip.
    if (method == PaymentMethod.cash) {
      final result = PaymentResult(
        status: PaymentStatus.pending,
        reference: reference,
        message: 'Pay the provider in cash when the job is complete.',
      );
      await _recordTransaction(
        reference: result.reference,
        amount: amount,
        currency: currency,
        method: method,
        status: result.status,
        bookingId: bookingId,
      );
      return result;
    }

    if (method == PaymentMethod.bankTransfer) {
      final result = PaymentResult(
        status: PaymentStatus.pending,
        reference: reference,
        message: 'Transfer to the SwiftServe account and upload your receipt.',
      );
      await _recordTransaction(
        reference: result.reference,
        amount: amount,
        currency: currency,
        method: method,
        status: result.status,
        bookingId: bookingId,
      );
      return result;
    }

    PaymentResult result;
    try {
      result = await gateway.initialize(
        amount: amount,
        currency: currency,
        email: email,
        reference: reference,
        bookingId: bookingId,
      );
    } catch (e) {
      result = PaymentResult(
        status: PaymentStatus.failed,
        reference: reference,
        message: 'Could not start payment: $e',
      );
    }

    await _recordTransaction(
      reference: result.reference,
      amount: amount,
      currency: currency,
      method: method,
      status: result.status,
      bookingId: bookingId,
    );
    return result;
  }

  Future<void> _recordTransaction({
    required String reference,
    required double amount,
    required String currency,
    required PaymentMethod method,
    required PaymentStatus status,
    required String bookingId,
  }) async {
    if (!_firebaseReady) return;
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      await _firestore.collection('transactions').doc(reference).set({
        'reference': reference,
        'amount': amount,
        'currency': currency,
        'method': method.name,
        'status': status.name,
        'bookingId': bookingId,
        'userId': uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {
      // Payment records are best-effort until security rules are deployed.
    }
  }
}
