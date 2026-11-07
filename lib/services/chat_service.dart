import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import '../models/provider.dart';
import '../models/app_notification.dart';
import 'notification_service.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  static const String _conversationsKey = 'swiftserve_chat_conversations';
  static const String _messagesPrefix = 'swiftserve_chat_messages_';

  final ValueNotifier<List<Conversation>> conversationsNotifier = ValueNotifier<List<Conversation>>([]);
  final ValueNotifier<int> unreadCountNotifier = ValueNotifier<int>(0);
  final ValueNotifier<Map<String, bool>> typingStatusNotifier = ValueNotifier<Map<String, bool>>({});
  final Map<String, ValueNotifier<List<Message>>> _conversationMessagesNotifiers = {};

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();

    final jsonList = prefs.getStringList(_conversationsKey);
    List<Conversation> list = [];

    if (jsonList != null && jsonList.isNotEmpty) {
      list = jsonList.map((str) => Conversation.fromJson(jsonDecode(str) as Map<String, dynamic>)).toList();
    } else {
      list = _getSeedConversations();
      await _persistConversations(list);
      // Seed default messages for conversation '1'
      await _seedDefaultMessages();
    }

    conversationsNotifier.value = list;
    _updateUnreadCount(list);
    _initialized = true;
  }

  ValueNotifier<List<Message>> getMessageNotifier(String conversationId) {
    if (!_conversationMessagesNotifiers.containsKey(conversationId)) {
      _conversationMessagesNotifiers[conversationId] = ValueNotifier<List<Message>>([]);
      // Load asynchronously into the notifier
      getMessages(conversationId).then((msgs) {
        _conversationMessagesNotifiers[conversationId]!.value = msgs;
      });
    }
    return _conversationMessagesNotifiers[conversationId]!;
  }

  Future<List<Message>> getMessages(String conversationId) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList('$_messagesPrefix$conversationId');
    if (jsonList != null && jsonList.isNotEmpty) {
      return jsonList.map((str) => Message.fromJson(jsonDecode(str) as Map<String, dynamic>)).toList();
    }

    if (conversationId == '1') {
      return _getDefaultSeedMessages();
    }

    // Default introductory message for other conversations
    final conv = conversationsNotifier.value.firstWhere(
      (c) => c.id == conversationId,
      orElse: () => Conversation(id: conversationId, providerName: 'Provider', lastMessage: '', time: ''),
    );

    return [
      Message(
        id: 'msg_welcome_$conversationId',
        senderId: 'provider',
        text: conv.lastMessage.isNotEmpty ? conv.lastMessage : "Hello! How can I assist you today?",
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isMe: false,
      ),
    ];
  }

  Future<Message> sendMessage({
    required String conversationId,
    required String text,
    String? imageUrl,
  }) async {
    await init();
    final currentMessages = await getMessages(conversationId);

    final newMessage = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'me',
      text: text,
      timestamp: DateTime.now(),
      isMe: true,
      imageUrl: imageUrl,
    );

    final updatedMessages = List<Message>.from(currentMessages)..add(newMessage);
    await _persistMessages(conversationId, updatedMessages);

    // Update conversation item
    _updateConversationLastMessage(
      conversationId: conversationId,
      lastMessage: text.isNotEmpty ? text : '📷 Shared a photo',
      time: 'Just now',
      isUnread: false,
    );

    // Trigger realistic provider auto-reply
    _scheduleProviderReply(conversationId, text, imageUrl);

    return newMessage;
  }

  void _scheduleProviderReply(String conversationId, String userText, String? imageUrl) {
    // 1. Show typing indicator after a brief delay
    Timer(const Duration(milliseconds: 600), () {
      final currentTyping = Map<String, bool>.from(typingStatusNotifier.value);
      currentTyping[conversationId] = true;
      typingStatusNotifier.value = currentTyping;
    });

    // 2. Deliver provider message after realistic typing interval
    Timer(const Duration(milliseconds: 2200), () async {
      final currentTyping = Map<String, bool>.from(typingStatusNotifier.value);
      currentTyping[conversationId] = false;
      typingStatusNotifier.value = currentTyping;

      final replyText = _generateSmartReply(userText, imageUrl);
      final replyMessage = Message(
        id: 'msg_reply_${DateTime.now().millisecondsSinceEpoch}',
        senderId: 'provider',
        text: replyText,
        timestamp: DateTime.now(),
        isMe: false,
      );

      final currentMsgs = await getMessages(conversationId);
      final updated = List<Message>.from(currentMsgs)..add(replyMessage);
      await _persistMessages(conversationId, updated);

      _updateConversationLastMessage(
        conversationId: conversationId,
        lastMessage: replyText,
        time: 'Just now',
        isUnread: true,
      );

      // Register notification alert
      final conv = conversationsNotifier.value.firstWhere(
        (c) => c.id == conversationId,
        orElse: () => Conversation(id: conversationId, providerName: 'Provider', lastMessage: '', time: ''),
      );
      NotificationService().addNotification(
        title: 'New message from ${conv.providerName}',
        body: replyText,
        type: NotificationType.booking,
        actionRoute: 'chat',
        actionPayload: conversationId,
      );
    });
  }

  String _generateSmartReply(String input, String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return "Thanks for sending the photo! That gives me a clear picture of what's required. I'll bring the right gear.";
    }

    final lower = input.toLowerCase();
    if (lower.contains('where') || lower.contains('arrive') || lower.contains('time') || lower.contains('when') || lower.contains('soon')) {
      return "I'm finishing up my previous slot nearby and will be with you in about 10-15 minutes!";
    }
    if (lower.contains('price') || lower.contains('cost') || lower.contains('charge') || lower.contains('how much') || lower.contains('cash') || lower.contains('transfer')) {
      return "My pricing is completely transparent as listed on my SwiftServe profile. Cash or in-app transfer both work great!";
    }
    if (lower.contains('hello') || lower.contains('hi') || lower.contains('hey')) {
      return "Hello! Thanks for reaching out. Please let me know any specific instructions for the location.";
    }
    if (lower.contains('leak') || lower.contains('pipe') || lower.contains('water') || lower.contains('broken') || lower.contains('fix')) {
      return "Understood. Please keep the water main valve shut if possible, I'll attend to it immediately upon arrival.";
    }
    if (lower.contains('thank') || lower.contains('ok') || lower.contains('alright') || lower.contains('cool')) {
      return "You're very welcome! See you shortly.";
    }

    return "Got your message! I've noted down the details and I'm on it.";
  }

  Future<void> markAsRead(String conversationId) async {
    final list = List<Conversation>.from(conversationsNotifier.value);
    final index = list.indexWhere((c) => c.id == conversationId);
    if (index != -1 && list[index].isUnread) {
      list[index] = list[index].copyWith(isUnread: false);
      conversationsNotifier.value = list;
      _updateUnreadCount(list);
      await _persistConversations(list);
    }
  }

  Future<Conversation> getOrCreateConversationForProvider(Provider provider) async {
    await init();
    final list = List<Conversation>.from(conversationsNotifier.value);
    final existingIndex = list.indexWhere(
      (c) => c.providerName.toLowerCase() == provider.name.toLowerCase() || c.id == 'conv_prov_${provider.id}',
    );

    if (existingIndex != -1) {
      return list[existingIndex];
    }

    // Create new conversation
    final newConv = Conversation(
      id: 'conv_prov_${provider.id}',
      providerName: provider.name,
      lastMessage: "Hello! Let me know how I can help with your service.",
      time: 'Just now',
      avatarUrl: provider.imageUrl,
      isOnline: true,
      isUnread: false,
    );

    list.insert(0, newConv);
    conversationsNotifier.value = list;
    await _persistConversations(list);

    // Seed initial message
    await _persistMessages(newConv.id, [
      Message(
        id: 'msg_init_${newConv.id}',
        senderId: 'provider',
        text: "Hello! Thanks for viewing my profile. Feel free to ask any questions about my services or availability.",
        timestamp: DateTime.now(),
        isMe: false,
      )
    ]);

    return newConv;
  }

  Future<void> deleteConversation(String conversationId) async {
    final list = List<Conversation>.from(conversationsNotifier.value);
    list.removeWhere((c) => c.id == conversationId);
    conversationsNotifier.value = list;
    _updateUnreadCount(list);
    await _persistConversations(list);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_messagesPrefix$conversationId');
  }

  void _updateConversationLastMessage({
    required String conversationId,
    required String lastMessage,
    required String time,
    required bool isUnread,
  }) async {
    final list = List<Conversation>.from(conversationsNotifier.value);
    final index = list.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      final updated = list[index].copyWith(
        lastMessage: lastMessage,
        time: time,
        isUnread: isUnread,
      );
      list.removeAt(index);
      list.insert(0, updated);
      conversationsNotifier.value = list;
      _updateUnreadCount(list);
      await _persistConversations(list);
    }
  }

  void _updateUnreadCount(List<Conversation> list) {
    final count = list.where((c) => c.isUnread).length;
    unreadCountNotifier.value = count;
  }

  Future<void> _persistConversations(List<Conversation> list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = list.map((c) => jsonEncode(c.toJson())).toList();
    await prefs.setStringList(_conversationsKey, jsonList);
  }

  Future<void> _persistMessages(String conversationId, List<Message> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = messages.map((m) => jsonEncode(m.toJson())).toList();
    await prefs.setStringList('$_messagesPrefix$conversationId', jsonList);

    if (_conversationMessagesNotifiers.containsKey(conversationId)) {
      _conversationMessagesNotifiers[conversationId]!.value = messages;
    }
  }

  Future<void> _seedDefaultMessages() async {
    await _persistMessages('1', _getDefaultSeedMessages());
  }

  List<Message> _getDefaultSeedMessages() {
    return [
      Message(
        id: '1',
        senderId: 'provider',
        text: "Hello! I've received your request for the leaking pipe.",
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        isMe: false,
      ),
      Message(
        id: '2',
        senderId: 'me',
        text: "Hi! Yes, it's getting quite messy. How soon can you be here?",
        timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
        isMe: true,
      ),
      Message(
        id: '3',
        senderId: 'provider',
        text: "I'm finishing up another job nearby. I can be there in about 20 minutes.",
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isMe: false,
      ),
      Message(
        id: 'mock_img',
        senderId: 'me',
        text: "Sending you a photo of the leak location.",
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
        isMe: true,
        imageUrl: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?q=80&w=1000&auto=format&fit=crop',
      ),
      Message(
        id: '4',
        senderId: 'provider',
        text: "I've arrived at your location, please come out when you're ready.",
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        isMe: false,
      ),
    ];
  }

  List<Conversation> _getSeedConversations() {
    return [
      Conversation(
        id: '1',
        providerName: 'TechFix Mobile',
        lastMessage: "I've arrived at your location, please come out...",
        time: '2:45 PM',
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCFQ7PW4mJq0pCsms1S5jz6jktvhtIvJQ9pCJONsOidljGYa7n-oOe3IfKlHfO8bAO2UdEGUQFcIaTidjxESclQcNwqAVjyIKdxjfQkF5l0qxfkG5_GnqCv55JJpxEb5piWICYx5fyA3b8zNi6xi5Sn8JYfwGGQEgmJW_hQWFG2K685urWWLtHgOjZkVBxQ9xxK4TOrOfOo619efYpLS_RSNTrKfwdGF9_rsCbFrv3wy1fv9nPbKlWmBLHpJsNhKJmqCGzElH2jR2uT',
        isOnline: true,
        isUnread: true,
      ),
      Conversation(
        id: '2',
        providerName: 'Alex the Barber',
        lastMessage: 'Thanks for the booking! See you tomorrow at 10.',
        time: '11:20 AM',
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAQY-wJQBD18t4GYQjf_DFHRKKTDMbwPTEdf3y0G3_pnsISu96W29vq7mSX_7ZURbByCaRcP_rwjXjYO-jZ39d-I7PFbj8H7q9lk0z6UDFMsHpTKJPX0LUYEk6HZQPzr9xvCAnMpI8GxGKxTjSZNMYqcmy1Eh5VNKh3loa7SWv2WqNT7MEFGNFATRVabclMw7Qq5uPMRZcpobPAT3CZrA8ovg5y72uAKbEJ2BZxTDmO-i1v2g7Aq-imn2ikZzb3sMuRdbeEL2aXU0qS',
        isOnline: false,
        isUnread: false,
      ),
      Conversation(
        id: '3',
        providerName: "Mike's Plumbing",
        lastMessage: 'The invoice has been sent to your email.',
        time: 'Yesterday',
        isOnline: true,
        isUnread: false,
        providerIcon: 'plumbing',
      ),
      Conversation(
        id: '4',
        providerName: 'Sparkle Clean Co.',
        lastMessage: 'Your service has been canceled. Refund processed.',
        time: 'Oct 28',
        isOnline: false,
        isUnread: false,
        providerIcon: 'cleaning_services',
      ),
      Conversation(
        id: '5',
        providerName: 'PowerPro Experts',
        lastMessage: 'Is everything working correctly after the fix?',
        time: 'Oct 25',
        isOnline: false,
        isUnread: false,
        providerIcon: 'electrical_services',
      ),
    ];
  }
}
