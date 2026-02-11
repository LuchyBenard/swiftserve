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
}
