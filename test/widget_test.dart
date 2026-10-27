import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:swiftserve/models/user.dart';
import 'package:swiftserve/models/provider.dart';
import 'package:swiftserve/models/booking.dart';
import 'package:swiftserve/models/message.dart';
import 'package:swiftserve/models/conversation.dart';
import 'package:swiftserve/widgets/clippers/top_wave_clipper.dart';

void main() {
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

  group('SwiftServe Widget & Clipper Tests', () {
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
  });
}
