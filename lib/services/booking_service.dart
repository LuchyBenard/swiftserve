import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../models/booking.dart';

/// Firestore-backed booking service with an in-memory fallback so the app and
/// tests still work when Firebase is not configured.
class BookingService {
  static final BookingService _instance = BookingService._internal();
  factory BookingService() => _instance;
  BookingService._internal();

  final ValueNotifier<List<Booking>> bookingsNotifier =
      ValueNotifier<List<Booking>>([]);

  FirebaseFirestore? _firestoreInstance;
  FirebaseAuth? _authInstance;

  FirebaseFirestore get _firestore =>
      _firestoreInstance ??= FirebaseFirestore.instance;
  FirebaseAuth get _auth => _authInstance ??= FirebaseAuth.instance;

  bool _initialized = false;
  bool _localMode = false;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  final List<Booking> _localBookings = [];
  String? _activeOwnerId;
  String? _activeRole;

  bool get isLocalMode => _localMode;

  /// Returns the signed-in uid, or null when Firebase is not configured.
  String? get _currentUid {
    if (Firebase.apps.isEmpty) return null;
    return _auth.currentUser?.uid;
  }

  Future<void> init() async {
    if (_initialized) return;
    if (Firebase.apps.isEmpty) {
      _enableLocalMode();
      return;
    }
    _initialized = true;
  }

  void _enableLocalMode() {
    _localMode = true;
    _initialized = true;
    if (_localBookings.isEmpty) {
      _localBookings.addAll(_seedLocalBookings());
    }
    _refreshLocal();
  }

  List<Booking> _seedLocalBookings() {
    final now = DateTime.now();
    return [
      Booking(
        id: 'booking_local_1',
        providerName: 'TechFix Mobile',
        serviceType: 'Phone Repair',
        status: 'In Progress',
        date: 'Today',
        time: '2:00 PM',
        location: '123 Market St, SF',
        price: 120.0,
        imageUrl: '',
        clientId: 'me',
        providerId: 'provider_1',
        notes: 'Cracked screen, needs replacement.',
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(minutes: 20)),
      ),
      Booking(
        id: 'booking_local_2',
        providerName: 'John D.',
        serviceType: 'Haircut & Beard Trim',
        status: 'Confirmed',
        date: 'Tomorrow',
        time: '10:00 AM',
        location: 'Provider Shop',
        price: 45.0,
        imageUrl: '',
        clientId: 'me',
        providerId: 'provider_2',
        notes: '',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(hours: 5)),
      ),
      Booking(
        id: 'booking_local_3',
        providerName: "Mike's Plumbing",
        serviceType: 'Leak Fix',
        status: 'Completed',
        date: 'Oct 24',
        time: '4:30 PM',
        location: 'Home',
        price: 150.0,
        imageUrl: '',
        clientId: 'me',
        providerId: 'provider_3',
        notes: 'Kitchen sink leak.',
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now.subtract(const Duration(days: 18)),
      ),
      Booking(
        id: 'booking_local_4',
        providerName: 'Sparky Electricals',
        serviceType: 'Wiring Inspection',
        status: 'Canceled',
        date: 'Oct 12',
        time: '11:00 AM',
        location: 'Home',
        price: 80.0,
        imageUrl: '',
        clientId: 'me',
        providerId: 'provider_4',
        notes: 'Rescheduled by provider.',
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(days: 29)),
      ),
    ];
  }

  void _refreshLocal() {
    final sorted = List<Booking>.from(_localBookings)
      ..sort((a, b) {
        final aTime = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });
    bookingsNotifier.value = sorted;
  }

  /// Start listening to the signed-in client's bookings.
  Future<void> listenToClientBookings([String? clientId]) async {
    await init();
    final ownerId = clientId ?? _currentUid ?? 'me';
    _setActive(ownerId, 'client');
  }

  /// Start listening to the signed-in provider's bookings.
  Future<void> listenToProviderBookings([String? providerId]) async {
    await init();
    final ownerId = providerId ?? _currentUid ?? 'me';
    _setActive(ownerId, 'provider');
  }

  void _setActive(String ownerId, String role) {
    if (_localMode) {
      _activeOwnerId = ownerId;
      _activeRole = role;
      _refreshLocal();
      return;
    }

    _subscription?.cancel();
    _activeOwnerId = ownerId;
    _activeRole = role;

    final field = role == 'provider' ? 'providerId' : 'clientId';
    _subscription = _firestore
        .collection('bookings')
        .where(field, isEqualTo: ownerId)
        .snapshots()
        .listen((snapshot) {
          final bookings = snapshot.docs.map(Booking.fromFirestore).toList()
            ..sort((a, b) {
              final aTime =
                  a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
              final bTime =
                  b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
              return bTime.compareTo(aTime);
            });
          bookingsNotifier.value = bookings;
        });
  }

  Future<Booking> createBooking({
    required String providerName,
    required String serviceType,
    required String date,
    required String time,
    required String location,
    required double price,
    String imageUrl = '',
    String providerId = '',
    String notes = '',
    String status = 'Pending',
  }) async {
    await init();
    final clientId = _currentUid ?? 'me';

    if (_localMode) {
      final booking = Booking(
        id: 'booking_${DateTime.now().microsecondsSinceEpoch}',
        providerName: providerName,
        serviceType: serviceType,
        status: status,
        date: date,
        time: time,
        location: location,
        price: price,
        imageUrl: imageUrl,
        clientId: clientId,
        providerId: providerId,
        notes: notes,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _localBookings.insert(0, booking);
      _refreshLocal();
      return booking;
    }

    final doc = _firestore.collection('bookings').doc();
    final booking = Booking(
      id: doc.id,
      providerName: providerName,
      serviceType: serviceType,
      status: status,
      date: date,
      time: time,
      location: location,
      price: price,
      imageUrl: imageUrl,
      clientId: clientId,
      providerId: providerId,
      notes: notes,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await doc.set(booking.toFirestore());
    return booking;
  }

  Future<void> updateStatus(String bookingId, String status) async {
    await init();
    if (_localMode) {
      final index = _localBookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        _localBookings[index] = _localBookings[index].copyWith(
          status: status,
          updatedAt: DateTime.now(),
        );
        _refreshLocal();
      }
      return;
    }
    await _firestore.collection('bookings').doc(bookingId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> cancelBooking(String bookingId, {String? reason}) async {
    await init();
    if (_localMode) {
      final index = _localBookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        _localBookings[index] = _localBookings[index].copyWith(
          status: 'Canceled',
          notes: reason ?? _localBookings[index].notes,
          updatedAt: DateTime.now(),
        );
        _refreshLocal();
      }
      return;
    }
    await _firestore.collection('bookings').doc(bookingId).update({
      'status': 'Canceled',
      if (reason != null) 'notes': reason,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Bookings for the active owner. Falls back to all local bookings.
  List<Booking> get currentBookings {
    if (!_localMode) return bookingsNotifier.value;
    if (_activeOwnerId == null) return bookingsNotifier.value;
    // The local seed uses placeholder provider ids, so show every seeded job
    // to the provider demo instead of filtering to an empty list.
    if (_activeRole == 'provider' && _activeOwnerId == 'me') {
      return bookingsNotifier.value;
    }
    final field = _activeRole == 'provider' ? 'providerId' : 'clientId';
    return bookingsNotifier.value.where((b) {
      final value = field == 'providerId' ? b.providerId : b.clientId;
      return value == _activeOwnerId;
    }).toList();
  }

  Future<Booking?> getBooking(String bookingId) async {
    await init();
    if (_localMode) {
      for (final booking in _localBookings) {
        if (booking.id == bookingId) return booking;
      }
      return null;
    }
    final doc = await _firestore.collection('bookings').doc(bookingId).get();
    if (!doc.exists) return null;
    return Booking.fromFirestore(doc);
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}
