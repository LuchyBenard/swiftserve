import 'package:flutter_test/flutter_test.dart';
import 'package:swiftserve/models/booking.dart';
import 'package:swiftserve/services/booking_service.dart';
import 'package:swiftserve/services/payment_service.dart';
import 'package:swiftserve/services/provider_service.dart';

void main() {
  group('BookingService (local fallback)', () {
    test('seeds demo bookings when Firebase is unavailable', () async {
      final service = BookingService();
      await service.init();

      expect(service.isLocalMode, isTrue);
      expect(service.bookingsNotifier.value, isNotEmpty);
      expect(service.bookingsNotifier.value.length, greaterThanOrEqualTo(4));
    });

    test('creates, transitions and cancels a booking', () async {
      final service = BookingService();
      await service.init();

      final created = await service.createBooking(
        providerName: 'Test Provider',
        serviceType: 'Diagnostic',
        date: '2026-01-01',
        time: '09:00 AM',
        location: 'Test Address',
        price: 75.0,
        providerId: 'provider_test',
        notes: 'Unit test booking',
      );

      expect(created.status, 'Pending');
      expect(created.clientId, isNotEmpty);
      expect(created.price, 75.0);

      await service.updateStatus(created.id, 'Confirmed');
      final confirmed = service.bookingsNotifier.value.firstWhere(
        (b) => b.id == created.id,
      );
      expect(confirmed.status, 'Confirmed');

      await service.cancelBooking(created.id, reason: 'Changed plans');
      final canceled = service.bookingsNotifier.value.firstWhere(
        (b) => b.id == created.id,
      );
      expect(canceled.status, 'Canceled');
      expect(canceled.notes, 'Changed plans');
    });

    test('filters current bookings by active client', () async {
      final service = BookingService();
      await service.init();
      await service.listenToClientBookings('me');

      expect(service.currentBookings, isNotEmpty);
      expect(service.currentBookings.every((b) => b.clientId == 'me'), isTrue);
    });

    test('Booking JSON roundtrip keeps marketplace fields', () {
      final booking = Booking(
        id: 'b1',
        providerName: 'Provider',
        serviceType: 'Service',
        status: 'Pending',
        date: '2026-01-01',
        time: '10:00 AM',
        location: 'Address',
        price: 10,
        imageUrl: '',
        clientId: 'client_1',
        providerId: 'provider_1',
        notes: 'Notes',
      );

      final restored = Booking.fromJson(booking.toJson());
      expect(restored.clientId, 'client_1');
      expect(restored.providerId, 'provider_1');
      expect(restored.notes, 'Notes');
      expect(restored.isActive, isTrue);
    });
  });

  group('PaymentService', () {
    test('cash payments are recorded as pending', () async {
      final result = await PaymentService().pay(
        amount: 120,
        method: PaymentMethod.cash,
        email: 'client@swiftserve.app',
      );

      expect(result.status, PaymentStatus.pending);
      expect(result.reference, startsWith('SS-'));
      expect(result.isSuccessful, isFalse);
    });

    test('mock card gateway approves payments offline', () async {
      final service = PaymentService()..gateway = MockPaymentGateway();
      final result = await service.pay(
        amount: 50,
        method: PaymentMethod.card,
        email: 'client@swiftserve.app',
      );

      expect(result.isSuccessful, isTrue);
      expect(result.status, PaymentStatus.successful);
    });
  });

  group('ProviderService (local fallback)', () {
    test('returns curated providers for a category', () async {
      final providers = await ProviderService().fetchProviders('Stylist');

      expect(providers, isNotEmpty);
      expect(providers.first.services, isNotEmpty);
    });

    test('featured providers are available offline', () async {
      final providers = await ProviderService().fetchFeatured();

      expect(providers.length, greaterThanOrEqualTo(5));
      expect(providers.first.name, isNotEmpty);
    });
  });
}
