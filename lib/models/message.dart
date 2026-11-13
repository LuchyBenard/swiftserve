import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isMe;
  final String? imageUrl;

  Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isMe,
    this.imageUrl,
  });

  factory Message.fromFirestore(DocumentSnapshot snapshot) {
    final data =
        (snapshot.data() as Map<String, dynamic>?) ?? <String, dynamic>{};
    final rawTimestamp = data['timestamp'];
    final timestamp = rawTimestamp is Timestamp
        ? rawTimestamp.toDate()
        : rawTimestamp is DateTime
        ? rawTimestamp
        : DateTime.now();

    return Message(
      id: data['id'] as String? ?? snapshot.id,
      senderId: data['senderId'] as String? ?? '',
      text: data['text'] as String? ?? '',
      timestamp: timestamp,
      isMe: data['isMe'] as bool? ?? false,
      imageUrl: data['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'senderId': senderId,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'isMe': isMe,
      'imageUrl': imageUrl,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'isMe': isMe,
      'imageUrl': imageUrl,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String? ?? '',
      senderId: json['senderId'] as String? ?? '',
      text: json['text'] as String? ?? '',
      timestamp:
          DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
      isMe: json['isMe'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Message copyWith({
    String? id,
    String? senderId,
    String? text,
    DateTime? timestamp,
    bool? isMe,
    String? imageUrl,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isMe: isMe ?? this.isMe,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
