import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  final String id;
  final String providerName;
  final String avatarUrl;
  final String? providerIcon;
  final bool isOnline;
  final bool isUnread;
  final List<String> participants;
  final List<String> participantNames;
  final List<String> participantImages;
  final String lastMessage;
  final String time;
  final Timestamp? lastMessageTime;
  final Timestamp? createdAt;

  Conversation({
    required this.id,
    required this.providerName,
    this.avatarUrl = '',
    this.providerIcon,
    this.isOnline = false,
    this.isUnread = false,
    this.participants = const [],
    this.participantNames = const [],
    this.participantImages = const [],
    this.lastMessage = '',
    this.time = '',
    this.lastMessageTime,
    this.createdAt,
  });

  factory Conversation.fromFirestore(DocumentSnapshot snapshot) {
    final data =
        (snapshot.data() as Map<String, dynamic>?) ?? <String, dynamic>{};
    final lastMessageTime = data['lastMessageTime'] as Timestamp?;

    return Conversation(
      id: data['id'] as String? ?? snapshot.id,
      providerName: data['providerName'] as String? ?? '',
      avatarUrl: data['avatarUrl'] as String? ?? '',
      providerIcon: data['providerIcon'] as String?,
      isOnline: data['isOnline'] as bool? ?? false,
      isUnread: data['isUnread'] as bool? ?? !(data['isRead'] as bool? ?? true),
      participants: List<String>.from(data['participants'] ?? const []),
      participantNames: List<String>.from(data['participantNames'] ?? const []),
      participantImages: List<String>.from(
        data['participantImages'] ?? const [],
      ),
      lastMessage: data['lastMessage'] as String? ?? '',
      time: data['time'] as String? ?? _formatTimestamp(lastMessageTime),
      lastMessageTime: lastMessageTime,
      createdAt: data['createdAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'providerName': providerName,
      'avatarUrl': avatarUrl,
      'providerIcon': providerIcon,
      'isOnline': isOnline,
      'isUnread': isUnread,
      'participants': participants,
      'participantNames': participantNames,
      'participantImages': participantImages,
      'lastMessage': lastMessage,
      'time': time,
      'lastMessageTime': lastMessageTime,
      'createdAt': createdAt,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'providerName': providerName,
      'avatarUrl': avatarUrl,
      'providerIcon': providerIcon,
      'isOnline': isOnline,
      'isUnread': isUnread,
      'participants': participants,
      'participantNames': participantNames,
      'participantImages': participantImages,
      'lastMessage': lastMessage,
      'time': time,
      'lastMessageTime': lastMessageTime?.millisecondsSinceEpoch,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String? ?? '',
      providerName: json['providerName'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      providerIcon: json['providerIcon'] as String?,
      isOnline: json['isOnline'] as bool? ?? false,
      isUnread: json['isUnread'] as bool? ?? false,
      participants: List<String>.from(json['participants'] ?? const []),
      participantNames: List<String>.from(json['participantNames'] ?? const []),
      participantImages: List<String>.from(
        json['participantImages'] ?? const [],
      ),
      lastMessage: json['lastMessage'] as String? ?? '',
      time: json['time'] as String? ?? '',
      lastMessageTime: _timestampFromJson(json['lastMessageTime']),
      createdAt: _timestampFromJson(json['createdAt']),
    );
  }

  Conversation copyWith({
    String? id,
    String? providerName,
    String? avatarUrl,
    String? providerIcon,
    bool? isOnline,
    bool? isUnread,
    List<String>? participants,
    List<String>? participantNames,
    List<String>? participantImages,
    String? lastMessage,
    String? time,
    Timestamp? lastMessageTime,
    Timestamp? createdAt,
  }) {
    return Conversation(
      id: id ?? this.id,
      providerName: providerName ?? this.providerName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      providerIcon: providerIcon ?? this.providerIcon,
      isOnline: isOnline ?? this.isOnline,
      isUnread: isUnread ?? this.isUnread,
      participants: participants ?? this.participants,
      participantNames: participantNames ?? this.participantNames,
      participantImages: participantImages ?? this.participantImages,
      lastMessage: lastMessage ?? this.lastMessage,
      time: time ?? this.time,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static Timestamp? _timestampFromJson(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value;
    if (value is int) return Timestamp.fromMillisecondsSinceEpoch(value);
    return null;
  }

  static String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final date = timestamp.toDate();
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) {
      return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    }
    return '${date.day}/${date.month}';
  }
}
