import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_notification.dart';
import '../services/notification_service.dart';
import 'tracking/job_tracking_page.dart';

class NotificationCenterPage extends StatefulWidget {
  const NotificationCenterPage({super.key});

  @override
  State<NotificationCenterPage> createState() => _NotificationCenterPageState();
}

class _NotificationCenterPageState extends State<NotificationCenterPage> {
  final NotificationService _notificationService = NotificationService();
  NotificationType? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _notificationService.init();
  }

  @override
  Widget build(BuildContext context) {
    const neonGreen = Color(0xFF25F46A);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background ambient neon glows
          Positioned(
            top: -120,
            right: -120,
            child: Container(
              width: 320,
              height: 320,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(37, 244, 106, 0.05),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -100,
            child: Container(
              width: 280,
              height: 280,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(37, 244, 106, 0.04),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(neonGreen),
                _buildFilterChips(neonGreen),
                const SizedBox(height: 12),
                Expanded(
                  child: ValueListenableBuilder<List<AppNotification>>(
                    valueListenable: _notificationService.notificationsNotifier,
                    builder: (context, notifications, _) {
                      final filtered = _selectedFilter == null
                          ? notifications
                          : notifications.where((n) => n.type == _selectedFilter).toList();

                      if (filtered.isEmpty) {
                        return _buildEmptyState();
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                        itemCount: filtered.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return _buildNotificationCard(item, neonGreen);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Color neonGreen) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Notifications',
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ValueListenableBuilder<int>(
                      valueListenable: _notificationService.unreadCountNotifier,
                      builder: (context, count, _) {
                        if (count == 0) return const SizedBox.shrink();
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: neonGreen,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: neonGreen.withValues(alpha: 0.5),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Text(
                            '$count new',
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Text(
                  'ALERTS & MARKETPLACE UPDATES',
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.grey[500],
                    fontSize: 10,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.done_all, color: Colors.white70, size: 22),
            tooltip: 'Mark all as read',
            onPressed: () async {
              await _notificationService.markAllAsRead();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('All notifications marked as read', style: GoogleFonts.spaceGrotesk()),
                    backgroundColor: const Color(0xFF1E1E1E),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.white70, size: 22),
            tooltip: 'Notification settings',
            onPressed: _showSettingsSheet,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(Color neonGreen) {
    final filters = <String, NotificationType?>{
      'All': null,
      'Bookings': NotificationType.booking,
      'Payments': NotificationType.payment,
      'Promos': NotificationType.promo,
      'Alerts': NotificationType.alert,
    };

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: filters.entries.map((entry) {
          final isSelected = _selectedFilter == entry.value;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(entry.key),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedFilter = entry.value);
                }
              },
              labelStyle: GoogleFonts.spaceGrotesk(
                color: isSelected ? Colors.black : Colors.grey[400],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 13,
              ),
              backgroundColor: const Color(0xFF101010),
              selectedColor: neonGreen,
              side: BorderSide(
                color: isSelected ? neonGreen : Colors.white.withValues(alpha: 0.08),
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              showCheckmark: false,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotificationCard(AppNotification item, Color neonGreen) {
    final Color accentColor = switch (item.type) {
      NotificationType.booking => neonGreen,
      NotificationType.payment => const Color(0xFFFFB703),
      NotificationType.promo => const Color(0xFF9D4EDD),
      NotificationType.alert => const Color(0xFFFF4D4D),
    };

    final IconData icon = switch (item.type) {
      NotificationType.booking => Icons.build_circle_outlined,
      NotificationType.payment => Icons.account_balance_wallet_outlined,
      NotificationType.promo => Icons.local_offer_outlined,
      NotificationType.alert => Icons.shield_outlined,
    };

    return Dismissible(
      key: Key('notif_${item.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Colors.redAccent.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(Icons.delete_outline, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Text(
              'Delete',
              style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      onDismissed: (_) async {
        await _notificationService.deleteNotification(item.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Notification removed', style: GoogleFonts.spaceGrotesk()),
              backgroundColor: const Color(0xFF1E1E1E),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: GestureDetector(
        onTap: () {
          _notificationService.markAsRead(item.id);
          _handleNotificationAction(item);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: item.isRead ? const Color(0xFF0C0C0C) : const Color(0xFF141414),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: item.isRead
                  ? Colors.white.withValues(alpha: 0.05)
                  : accentColor.withValues(alpha: 0.3),
              width: item.isRead ? 1.0 : 1.5,
            ),
            boxShadow: [
              if (!item.isRead)
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.1),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category icon badge
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(color: accentColor.withValues(alpha: 0.2)),
                ),
                child: Icon(icon, color: accentColor, size: 22),
              ),
              const SizedBox(width: 14),
              // Body content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: GoogleFonts.spaceGrotesk(
                              color: item.isRead ? Colors.grey[300] : Colors.white,
                              fontSize: 15,
                              fontWeight: item.isRead ? FontWeight.w600 : FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!item.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(left: 6),
                            decoration: BoxDecoration(
                              color: accentColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: accentColor.withValues(alpha: 0.6),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.body,
                      style: GoogleFonts.spaceGrotesk(
                        color: item.isRead ? Colors.grey[500] : Colors.grey[400],
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.timeAgo,
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.grey[600],
                            fontSize: 11,
                          ),
                        ),
                        if (item.actionRoute != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: accentColor.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.actionRoute == 'tracking' ? 'Track Job' : 'View Details',
                                  style: GoogleFonts.spaceGrotesk(
                                    color: accentColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(Icons.arrow_forward_ios, color: accentColor, size: 9),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF25F46A).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Color(0xFF25F46A),
                size: 54,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "You're All Caught Up!",
              style: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _selectedFilter == null
                  ? "No new notifications right now. Service and booking updates will appear here."
                  : "No notifications found under this category.",
              textAlign: TextAlign.center,
              style: GoogleFonts.spaceGrotesk(color: Colors.grey[500], fontSize: 14),
            ),
            if (_selectedFilter != null) ...[
              const SizedBox(height: 18),
              OutlinedButton(
                onPressed: () => setState(() => _selectedFilter = null),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF25F46A)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text('View All', style: GoogleFonts.spaceGrotesk(color: const Color(0xFF25F46A))),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _handleNotificationAction(AppNotification item) {
    if (item.actionRoute == 'tracking') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JobTrackingPage(
            providerName: item.actionPayload ?? 'TechFix Mobile',
            serviceType: 'Mobile Phone Repair',
            providerImageUrl: '',
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: const Color(0xFF141414),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            item.title,
            style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            item.body,
            style: GoogleFonts.spaceGrotesk(color: Colors.grey[300], fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Dismiss', style: GoogleFonts.spaceGrotesk(color: const Color(0xFF25F46A))),
            ),
          ],
        ),
      );
    }
  }

  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141414),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetCtx) {
        return ValueListenableBuilder<NotificationSettings>(
          valueListenable: _notificationService.settingsNotifier,
          builder: (context, settings, _) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 24,
                right: 24,
                bottom: MediaQuery.of(sheetCtx).padding.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Notification Settings',
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(sheetCtx);
                          await _notificationService.clearAll();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('All notifications cleared', style: GoogleFonts.spaceGrotesk()),
                                backgroundColor: const Color(0xFF1E1E1E),
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Clear All',
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Customize how SwiftServe delivers real-time marketplace alerts.',
                    style: GoogleFonts.spaceGrotesk(color: Colors.grey[400], fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  _buildSettingSwitch(
                    title: 'Push Notifications',
                    subtitle: 'Receive instant notifications when the app is in background',
                    value: settings.pushEnabled,
                    onChanged: (val) {
                      _notificationService.updateSettings(settings.copyWith(pushEnabled: val));
                    },
                  ),
                  _buildSettingSwitch(
                    title: 'Booking & Status Updates',
                    subtitle: 'Real-time alerts when providers accept, arrive, or complete jobs',
                    value: settings.bookingAlerts,
                    onChanged: (val) {
                      _notificationService.updateSettings(settings.copyWith(bookingAlerts: val));
                    },
                  ),
                  _buildSettingSwitch(
                    title: 'Promotions & Discounts',
                    subtitle: 'Discounts, coupon codes, and weekend promotional deals',
                    value: settings.promoAlerts,
                    onChanged: (val) {
                      _notificationService.updateSettings(settings.copyWith(promoAlerts: val));
                    },
                  ),
                  _buildSettingSwitch(
                    title: 'Sound & Vibration',
                    subtitle: 'Play alert sounds when urgent notifications are delivered',
                    value: settings.soundEnabled,
                    onChanged: (val) {
                      _notificationService.updateSettings(settings.copyWith(soundEnabled: val));
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSettingSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    const neonGreen = Color(0xFF25F46A);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.grey[500],
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: neonGreen,
            activeTrackColor: neonGreen.withValues(alpha: 0.3),
            inactiveThumbColor: Colors.grey[500],
            inactiveTrackColor: Colors.grey[800],
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
