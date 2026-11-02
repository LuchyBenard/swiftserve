class Conversation {
  final String id;
  final String providerName;
  final String lastMessage;
  final String time;
  final String avatarUrl;
  final bool isOnline;
  final bool isUnread; // Helper to show bright time/text if unread
  final String? providerIcon; // For those without images (plumber/electrician)

  Conversation({
    required this.id,
    required this.providerName,
    required this.lastMessage,
    required this.time,
    this.avatarUrl = '',
    this.isOnline = false,
    this.isUnread = false,
    this.providerIcon,
  });

  Conversation copyWith({
    String? id,
    String? providerName,
    String? lastMessage,
    String? time,
    String? avatarUrl,
    bool? isOnline,
    bool? isUnread,
    String? providerIcon,
  }) {
    return Conversation(
      id: id ?? this.id,
      providerName: providerName ?? this.providerName,
      lastMessage: lastMessage ?? this.lastMessage,
      time: time ?? this.time,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isOnline: isOnline ?? this.isOnline,
      isUnread: isUnread ?? this.isUnread,
      providerIcon: providerIcon ?? this.providerIcon,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'providerName': providerName,
      'lastMessage': lastMessage,
      'time': time,
      'avatarUrl': avatarUrl,
      'isOnline': isOnline,
      'isUnread': isUnread,
      'providerIcon': providerIcon,
    };
  }

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      providerName: json['providerName'] as String,
      lastMessage: json['lastMessage'] as String? ?? '',
      time: json['time'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      isOnline: json['isOnline'] as bool? ?? false,
      isUnread: json['isUnread'] as bool? ?? false,
      providerIcon: json['providerIcon'] as String?,
    );
  }
}
