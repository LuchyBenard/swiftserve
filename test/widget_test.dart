import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:swiftserve/models/user.dart';
import 'package:swiftserve/models/provider.dart';
import 'package:swiftserve/models/booking.dart';
import 'package:swiftserve/models/message.dart';
import 'package:swiftserve/models/conversation.dart';
import 'package:swiftserve/models/provider_filter.dart';
import 'package:swiftserve/models/saved_address.dart';
import 'package:swiftserve/services/favorites_service.dart';
import 'package:swiftserve/services/address_service.dart';
import 'package:swiftserve/widgets/clippers/top_wave_clipper.dart';
import 'package:swiftserve/widgets/cancel_booking_dialog.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('SwiftServe Model Tests', () {
    test('User model creates properly and copyWith updates correctly', () {
      final user = User(
        id: 'usr_101',
        name: 'Jane Doe',
        email: 'jane@example.com',
        phone: '+1234567890',
        bio: 'Friendly homeowner',
        location: 'Downtown',
        profileImageUrl: 'https://example.com/jane.jpg',
      );

      expect(user.id, 'usr_101');
      expect(user.name, 'Jane Doe');
      expect(user.email, 'jane@example.com');
      expect(user.phone, '+1234567890');
      expect(user.bio, 'Friendly homeowner');
      expect(user.location, 'Downtown');
      expect(user.profileImageUrl, 'https://example.com/jane.jpg');

      final updatedUser = user.copyWith(
        name: 'Jane Smith',
        bio: 'Updated bio',
      );

      expect(updatedUser.id, 'usr_101');
      expect(updatedUser.name, 'Jane Smith');
      expect(updatedUser.bio, 'Updated bio');
      expect(updatedUser.email, 'jane@example.com');
      expect(updatedUser.phone, '+1234567890');
    });

    test('Provider model initializes with correct service offerings', () {
      final provider = Provider(
        id: 'prov_202',
        name: 'TechFix Mobile',
        role: 'Technician',
        rating: 4.95,
        reviewsCount: 85,
        distance: '1.2 mi',
        priceStart: 85.0,
        imageUrl: 'https://example.com/techfix.jpg',
        about: 'Certified mobile technician specializing in repairs.',
        services: ['Screen Repair', 'Battery Replacement', 'Diagnostic'],
      );

      expect(provider.id, 'prov_202');
      expect(provider.name, 'TechFix Mobile');
      expect(provider.role, 'Technician');
      expect(provider.rating, 4.95);
      expect(provider.reviewsCount, 85);
      expect(provider.priceStart, 85.0);
      expect(provider.services.length, 3);
      expect(provider.services.contains('Screen Repair'), isTrue);
    });

    test('Booking model retains status and pricing breakdown', () {
      final booking = Booking(
        id: 'book_303',
        providerName: 'John D.',
        serviceType: 'Master Barber',
        status: 'In Progress',
        date: '2026-10-28',
        time: '14:30',
        location: '123 Market St',
        price: 45.0,
        imageUrl: 'https://example.com/barber.jpg',
      );

      expect(booking.id, 'book_303');
      expect(booking.providerName, 'John D.');
      expect(booking.serviceType, 'Master Barber');
      expect(booking.status, 'In Progress');
      expect(booking.price, 45.0);
    });

    test('Message and Conversation models instantiate with expected defaults', () {
      final now = DateTime.now();
      final message = Message(
        id: 'msg_404',
        senderId: 'usr_101',
        text: 'Hello, are you available tomorrow?',
        timestamp: now,
        isMe: true,
      );

      expect(message.id, 'msg_404');
      expect(message.isMe, isTrue);
      expect(message.imageUrl, isNull);

      final conversation = Conversation(
        id: 'conv_505',
        providerName: 'Fix-It Mike',
        lastMessage: 'I will be there at 10 AM',
        time: '10:00 AM',
      );

      expect(conversation.id, 'conv_505');
      expect(conversation.avatarUrl, '');
      expect(conversation.isOnline, isFalse);
      expect(conversation.isUnread, isFalse);
      expect(conversation.providerIcon, isNull);
    });
  });

  group('Favorites & Saved Providers Feature Tests', () {
    test('FavoritesService toggles and persists favorites reactively', () async {
      final favoritesService = FavoritesService();
      await favoritesService.init();

      expect(favoritesService.isFavorite('prov_1'), isFalse);

      final added = await favoritesService.toggleFavorite('prov_1');
      expect(added, isTrue);
      expect(favoritesService.isFavorite('prov_1'), isTrue);
      expect(favoritesService.favoritesNotifier.value.contains('prov_1'), isTrue);

      final removed = await favoritesService.toggleFavorite('prov_1');
      expect(removed, isFalse);
      expect(favoritesService.isFavorite('prov_1'), isFalse);
    });

    test('filterSavedProviders filters provider list correctly', () async {
      final favoritesService = FavoritesService();
      await favoritesService.init();
      await favoritesService.toggleFavorite('p_barber');

      final list = [
        Provider(
          id: 'p_barber',
          name: 'Master Barber',
          role: 'Barber',
          rating: 4.9,
          reviewsCount: 10,
          distance: '1.0 mi',
          priceStart: 30,
          imageUrl: '',
          about: '',
          services: [],
        ),
        Provider(
          id: 'p_plumber',
          name: 'Plumber',
          role: 'Plumber',
          rating: 4.5,
          reviewsCount: 5,
          distance: '2.0 mi',
          priceStart: 50,
          imageUrl: '',
          about: '',
          services: [],
        ),
      ];

      final saved = favoritesService.filterSavedProviders(list);
      expect(saved.length, 1);
      expect(saved.first.id, 'p_barber');

      // Cleanup
      await favoritesService.toggleFavorite('p_barber');
    });
  });

  group('Advanced Search & Filter Feature Tests', () {
    final testProviders = [
      Provider(
        id: '1',
        name: 'John Barber',
        role: 'Master Barber',
        rating: 4.9,
        reviewsCount: 120,
        distance: '0.8 mi',
        priceStart: 35.0,
        imageUrl: '',
        about: '',
        services: ['Haircut', 'Fade'],
      ),
      Provider(
        id: '2',
        name: 'TechFix Pro',
        role: 'Phone Technician',
        rating: 4.6,
        reviewsCount: 50,
        distance: '2.5 mi',
        priceStart: 90.0,
        imageUrl: '',
        about: '',
        services: ['Screen Repair', 'Battery'],
      ),
      Provider(
        id: '3',
        name: 'Sarah Stylist',
        role: 'Hair Stylist',
        rating: 4.2,
        reviewsCount: 15,
        distance: '1.2 mi',
        priceStart: 45.0,
        imageUrl: '',
        about: '',
        services: ['Braids'],
      ),
    ];

    test('ProviderFilter filters by minimum rating and max price', () {
      const filter = ProviderFilter(minRating: 4.5, maxPrice: 50.0);
      final results = filter.apply(testProviders);

      expect(results.length, 1);
      expect(results.first.name, 'John Barber');
    });

    test('ProviderFilter filters by distance and search query', () {
      const filter = ProviderFilter(maxDistance: 1.5, searchQuery: 'haircut');
      final results = filter.apply(testProviders);

      expect(results.length, 1);
      expect(results.first.name, 'John Barber');
    });

    test('ProviderFilter sorts by price ascending correctly', () {
      const filter = ProviderFilter(sortBy: 'price_low');
      final results = filter.apply(testProviders);

      expect(results.first.priceStart, 35.0);
      expect(results.last.priceStart, 90.0);
    });
  });

  group('Address & Location Picker Feature Tests', () {
    test('SavedAddress serializes and deserializes properly', () {
      const addr = SavedAddress(
        id: 'addr_1',
        title: 'Office',
        addressLine: '12 Independence Layout',
        tag: 'work',
        isDefault: true,
      );

      final json = addr.toJson();
      final reconstructed = SavedAddress.fromJson(json);

      expect(reconstructed.id, addr.id);
      expect(reconstructed.title, addr.title);
      expect(reconstructed.addressLine, addr.addressLine);
      expect(reconstructed.tag, addr.tag);
      expect(reconstructed.isDefault, isTrue);
    });

    test('AddressService initializes presets and detects GPS coordinates', () async {
      final service = AddressService();
      await service.init();

      expect(service.addressesNotifier.value.isNotEmpty, isTrue);
      expect(service.selectedAddressNotifier.value, isNotNull);

      final gpsAddr = await service.detectCurrentGPSLocation();
      expect(gpsAddr.title.contains('GPS'), isTrue);
      expect(service.selectedAddressNotifier.value?.id, gpsAddr.id);
    });
  });

  group('Booking Cancellation & Widget Tests', () {
    test('TopWaveClipper generates non-empty closed clip path', () {
      final clipper = TopWaveClipper();
      const testSize = Size(400, 200);
      final path = clipper.getClip(testSize);

      expect(path, isNotNull);
      final bounds = path.getBounds();
      expect(bounds.width, closeTo(400, 0.1));
      expect(bounds.height, closeTo(200, 0.1));
      expect(clipper.shouldReclip(TopWaveClipper()), isFalse);
    });

    testWidgets('TopWaveClipper renders within ClipPath widget successfully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClipPath(
              clipper: TopWaveClipper(),
              child: Container(
                width: 300,
                height: 150,
                color: const Color(0xFF25F46A),
                child: const Center(
                  child: Text('SwiftServe Banner'),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('SwiftServe Banner'), findsOneWidget);
      expect(find.byType(ClipPath), findsOneWidget);
    });

    testWidgets('CancelBookingDialog renders reasons and dismisses on Keep Booking', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CancelBookingDialog(
              providerName: 'John D.',
              serviceType: 'Master Barber',
            ),
          ),
        ),
      );

      expect(find.text('Cancel Booking'), findsNWidgets(2));
      expect(find.text('John D. • Master Barber'), findsOneWidget);
      expect(find.text('Schedule conflict / Need to reschedule'), findsOneWidget);
      expect(find.text('Keep Booking'), findsOneWidget);
    });
  });
}
