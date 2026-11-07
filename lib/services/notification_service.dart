import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_notification.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static const String _notificationsKey = 'swiftserve_notifications_v1';
  static const String _settingsKey = 'swiftserve_notification_settings_v1';

  final ValueNotifier<List<AppNotification>> notificationsNotifier =
      ValueNotifier<List<AppNotification>>([]);
  final ValueNotifier<int> unreadCountNotifier = ValueNotifier<int>(0);
  final ValueNotifier<NotificationSettings> settingsNotifier =
      ValueNotifier<NotificationSettings>(const NotificationSettings());

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();

    // 1. Load settings
    final settingsJson = prefs.getString(_settingsKey);
    if (settingsJson != null) {
      try {
        final decoded = jsonDecode(settingsJson) as Map<String, dynamic>;
        settingsNotifier.value = NotificationSettings.fromJson(decoded);
      } catch (_) {}
    }

    // 2. Load notifications
    final jsonList = prefs.getStringList(_notificationsKey);
    List<AppNotification> list = [];

    if (jsonList != null && jsonList.isNotEmpty) {
      try {
        list = jsonList
            .map((str) => AppNotification.fromJson(jsonDecode(str) as Map<String, dynamic>))
            .toList();
      } catch (_) {
        list = _getSeedNotifications();
      }
    } else {
      list = _getSeedNotifications();
      await _persistNotifications(list);
    }

    notificationsNotifier.value = list;
    _updateUnreadCount(list);
    _initialized = true;
  }

  Future<void> markAsRead(String id) async {
    final list = List<AppNotification>.from(notificationsNotifier.value);
    final index = list.indexWhere((n) => n.id == id);
    if (index != -1 && !list[index].isRead) {
      list[index] = list[index].copyWith(isRead: true);
      notificationsNotifier.value = list;
      _updateUnreadCount(list);
      await _persistNotifications(list);
    }
  }

  Future<void> markAllAsRead() async {
    final list = notificationsNotifier.value.map((n) => n.copyWith(isRead: true)).toList();
    notificationsNotifier.value = list;
    _updateUnreadCount(list);
    await _persistNotifications(list);
  }

  Future<void> deleteNotification(String id) async {
    final list = List<AppNotification>.from(notificationsNotifier.value);
    list.removeWhere((n) => n.id == id);
    notificationsNotifier.value = list;
    _updateUnreadCount(list);
    await _persistNotifications(list);
  }

  Future<void> clearAll() async {
    notificationsNotifier.value = [];
    _updateUnreadCount([]);
    await _persistNotifications([]);
  }

  Future<AppNotification> addNotification({
    required String title,
    required String body,
    required NotificationType type,
    String? actionRoute,
    String? actionPayload,
    BuildContext? context,
  }) async {
    await init();

    final newNotification = AppNotification(
      id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      body: body,
      timestamp: DateTime.now(),
      type: type,
      isRead: false,
      actionRoute: actionRoute,
      actionPayload: actionPayload,
    );

    final list = List<AppNotification>.from(notificationsNotifier.value);
    list.insert(0, newNotification);
    notificationsNotifier.value = list;
    _updateUnreadCount(list);
    await _persistNotifications(list);

    if (context != null && context.mounted) {
      showInAppBanner(context, newNotification);
    }

    return newNotification;
  }

  Future<void> updateSettings(NotificationSettings newSettings) async {
    settingsNotifier.value = newSettings;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(newSettings.toJson()));
  }

  void _updateUnreadCount(List<AppNotification> list) {
    final count = list.where((n) => !n.isRead).length;
    unreadCountNotifier.value = count;
  }

  Future<void> _persistNotifications(List<AppNotification> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = list.map((n) => jsonEncode(n.toJson())).toList();
    await prefs.setStringList(_notificationsKey, jsonList);
  }

  void showInAppBanner(BuildContext context, AppNotification notification, {VoidCallback? onTap}) {
    final overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    final Color accentColor = switch (notification.type) {
      NotificationType.booking => const Color(0xFF25F46A),
      NotificationType.payment => const Color(0xFFFFB703),
      NotificationType.promo => const Color(0xFF9D4EDD),
      NotificationType.alert => const Color(0xFFFF4D4D),
    };

    final IconData icon = switch (notification.type) {
      NotificationType.booking => Icons.build_circle_outlined,
      NotificationType.payment => Icons.account_balance_wallet_outlined,
      NotificationType.promo => Icons.local_offer_outlined,
      NotificationType.alert => Icons.shield_outlined,
    };

    overlayEntry = OverlayEntry(
      builder: (ctx) => Positioned(
        top: MediaQuery.of(ctx).padding.top + 10,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: -50.0, end: 0.0),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            builder: (context, yOffset, child) {
              return Transform.translate(
                offset: Offset(0, yOffset),
                child: child,
              );
            },
            child: GestureDetector(
              onTap: () {
                markAsRead(notification.id);
                overlayEntry.remove();
                if (onTap != null) {
                  onTap();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: accentColor.withValues(alpha: 0.4), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.25),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: accentColor, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  notification.title,
                                  style: GoogleFonts.spaceGrotesk(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                'Just now',
                                style: GoogleFonts.spaceGrotesk(
                                  color: Colors.grey[500],
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notification.body,
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.grey[300],
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey, size: 18),
                      onPressed: () => overlayEntry.remove(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);

    // Auto dismiss after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  List<AppNotification> _getSeedNotifications() {
    return [
      AppNotification(
        id: 'notif_1',
        title: 'Artisan Has Arrived! 📍',
        body: 'TechFix Mobile has arrived at your service address. Please be ready to meet them.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        type: NotificationType.booking,
        isRead: false,
        actionRoute: 'tracking',
        actionPayload: 'TechFix Mobile',
      ),
      AppNotification(
        id: 'notif_2',
        title: 'Service Invoice #INV-2026-88',
        body: 'Your payment receipt of \$40.00 for John D. (Master Barber) is ready for download.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.payment,
        isRead: false,
        actionRoute: 'receipt',
      ),
      AppNotification(
        id: 'notif_3',
        title: 'Weekend Flash Deal ⚡',
        body: 'Enjoy 20% off all Plumbing & Electrical bookings this weekend with promo code SWIFT20.',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
        type: NotificationType.promo,
        isRead: false,
      ),
      AppNotification(
        id: 'notif_4',
        title: 'Booking Confirmed',
        body: "Mike's Plumbing accepted your emergency leak request scheduled for tomorrow at 10:00 AM.",
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.booking,
        isRead: true,
      ),
      AppNotification(
        id: 'notif_5',
        title: 'Account Security Verified 🛡️',
        body: 'Two-factor biometric login and phone verification completed successfully.',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        type: NotificationType.alert,
        isRead: true,
      ),
    ];
  }
}
