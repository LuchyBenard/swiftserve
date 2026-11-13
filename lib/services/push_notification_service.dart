import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/app_notification.dart';
import 'notification_service.dart';

/// Top-level handler required by FCM for messages received while the app is
/// terminated or in the background.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) return;
  // Firebase is already initialized by the native layer in release builds.
}

/// Wraps Firebase Cloud Messaging: permission handling, device tokens,
/// topic subscriptions, and foreground message routing into the in-app
/// notification center.
class PushNotificationService {
  static final PushNotificationService _instance =
      PushNotificationService._internal();
  factory PushNotificationService() => _instance;
  PushNotificationService._internal();

  FirebaseMessaging? _messaging;
  bool _initialized = false;
  String? _token;

  final StreamController<RemoteMessage> _foregroundController =
      StreamController<RemoteMessage>.broadcast();

  String? get token => _token;
  bool get isAvailable => Firebase.apps.isNotEmpty;
  Stream<RemoteMessage> get foregroundMessages => _foregroundController.stream;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    if (!isAvailable) return;

    try {
      _messaging = FirebaseMessaging.instance;
      await _messaging!.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      _token = await _messaging!.getToken();
      await _persistToken(_token);

      _messaging!.onTokenRefresh.listen((newToken) {
        _token = newToken;
        _persistToken(newToken);
      });

      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpened);
    } catch (_) {
      // Messaging is optional; never block startup on it.
    }
  }

  Future<String?> refreshToken() async {
    if (!isAvailable) return null;
    try {
      _token = await _messaging?.getToken();
      return _token;
    } catch (_) {
      return null;
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    if (!isAvailable) return;
    try {
      await _messaging?.subscribeToTopic(topic);
    } catch (_) {}
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    if (!isAvailable) return;
    try {
      await _messaging?.unsubscribeFromTopic(topic);
    } catch (_) {}
  }

  /// Stores the device token so Cloud Functions can target this user.
  Future<void> _persistToken(String? token) async {
    if (token == null || token.isEmpty) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'fcmToken': token,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {
      // Token persistence is best-effort.
    }
  }

  /// Subscribes the device to a role topic (e.g. `providers`, `clients`).
  Future<void> subscribeToRole(String role) async {
    if (role != 'provider' && role != 'client') return;
    await subscribeToTopic('${role}s');
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    _foregroundController.add(message);

    final notification = message.notification;
    final title =
        notification?.title ??
        message.data['title']?.toString() ??
        'SwiftServe';
    final body = notification?.body ?? message.data['body']?.toString() ?? '';

    if (body.isEmpty) return;

    final type = _typeFromData(message.data['type']?.toString());
    await NotificationService().addNotification(
      title: title,
      body: body,
      type: type,
      actionRoute: message.data['route']?.toString(),
      actionPayload: message.data['bookingId']?.toString(),
    );
  }

  void _handleMessageOpened(RemoteMessage message) {
    _foregroundController.add(message);
  }

  NotificationType _typeFromData(String? type) {
    switch (type) {
      case 'booking':
        return NotificationType.booking;
      case 'payment':
        return NotificationType.payment;
      case 'promo':
        return NotificationType.promo;
      default:
        return NotificationType.alert;
    }
  }

  void dispose() {
    _foregroundController.close();
  }
}
