enum NotificationType { booking, payment, promo, alert }

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;
  final String? actionRoute;
  final String? actionPayload;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.actionRoute,
    this.actionPayload,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? timestamp,
    NotificationType? type,
    bool? isRead,
    String? actionRoute,
    String? actionPayload,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      actionRoute: actionRoute ?? this.actionRoute,
      actionPayload: actionPayload ?? this.actionPayload,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
      'type': type.name,
      'isRead': isRead,
      if (actionRoute != null) 'actionRoute': actionRoute,
      if (actionPayload != null) 'actionPayload': actionPayload,
    };
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      timestamp:
          DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
      type: NotificationType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => NotificationType.alert,
      ),
      isRead: json['isRead'] as bool? ?? false,
      actionRoute: json['actionRoute'] as String?,
      actionPayload: json['actionPayload'] as String?,
    );
  }

  String get timeAgo {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inSeconds < 45) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${timestamp.month}/${timestamp.day}';
  }
}

class NotificationSettings {
  final bool pushEnabled;
  final bool bookingAlerts;
  final bool promoAlerts;
  final bool soundEnabled;

  const NotificationSettings({
    this.pushEnabled = true,
    this.bookingAlerts = true,
    this.promoAlerts = true,
    this.soundEnabled = true,
  });

  NotificationSettings copyWith({
    bool? pushEnabled,
    bool? bookingAlerts,
    bool? promoAlerts,
    bool? soundEnabled,
  }) {
    return NotificationSettings(
      pushEnabled: pushEnabled ?? this.pushEnabled,
      bookingAlerts: bookingAlerts ?? this.bookingAlerts,
      promoAlerts: promoAlerts ?? this.promoAlerts,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }

  Map<String, dynamic> toJson() => {
    'pushEnabled': pushEnabled,
    'bookingAlerts': bookingAlerts,
    'promoAlerts': promoAlerts,
    'soundEnabled': soundEnabled,
  };

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      pushEnabled: json['pushEnabled'] as bool? ?? true,
      bookingAlerts: json['bookingAlerts'] as bool? ?? true,
      promoAlerts: json['promoAlerts'] as bool? ?? true,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
    );
  }
}
