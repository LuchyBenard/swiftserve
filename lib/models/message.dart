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
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      text: json['text'] as String,
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
      isMe: json['isMe'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
