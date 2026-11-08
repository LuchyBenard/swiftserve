import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _initialized = false;
  bool _isAdmin = false;

  Future<void> init({bool isAdmin = false}) async {
    if (_initialized) return;
    _isAdmin = isAdmin;

    // Always initialize Firestore listeners
    await _initializeFirestore();

    _initialized = true;
  }

  Future<void> _initializeFirestore() async {
    // Set up real-time listeners for conversations
    _setupConversationListener();
    _setupUnreadCountListener();
  }

  Stream<QuerySnapshot> _conversationsStream() {
    return _firestore.collection('conversations').snapshots();
  }

  Stream<QuerySnapshot> _messagesStream(String conversationId) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  void _setupConversationListener() {
    _conversationsStream().listen((snapshot) {
      final List<Conversation> conversations = [];
      for (var doc in snapshot.docs) {
        conversations.add(Conversation.fromFirestore(doc));
      }
      // Sort by last message time, newest first
      conversations.sort((a, b) {
        final timeA = a.lastMessageTime?.toDate() ?? DateTime.now();
        final timeB = b.lastMessageTime?.toDate() ?? DateTime.now();
        return timeB.compareTo(timeA);
      });
      conversationsNotifier.value = conversations;
      _updateUnreadCount(conversations);
    });
  }

  void _setupUnreadCountListener() {
    _conversationsStream().listen((snapshot) {
      final List<Conversation> conversations = [];
      for (var doc in snapshot.docs) {
        conversations.add(Conversation.fromFirestore(doc));
      }
      _updateUnreadCount(conversations);
    });
  }

  void _updateUnreadCount(List<Conversation> list) {
    final count = list.where((c) => c.isUnread).length;
    unreadCountNotifier.value = count;
  }

  // Conversation methods
  Future<Conversation> createConversation({
    required String participantId,
    required String participantName,
    required String participantImageUrl,
  }) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    // Check if conversation already exists
    final existing = await _firestore
        .collection('conversations')
        .where('participants', arrayContains: userId)
        .where('participants', arrayContains: participantId)
        .get();

    if (existing.docs.isNotEmpty) {
      return Conversation.fromFirestore(existing.docs.first);
    }

    final convRef = await _firestore.collection('conversations').add({
      'participants': [userId, participantId],
      'participantNames': [userId.split('@').first, participantName],
      'participantImages': ['', participantImageUrl],
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
    });

    return Conversation.fromFirestore(convRef);
  }

  Future<void> sendMessage({
    required String conversationId,
    required String text,
    String? imageUrl,
  }) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    final messageRef = await _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .add({
      'senderId': userId,
      'text': text,
      'imageUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
      'isMe': true,
    });

    // Update conversation last message
    await _firestore.collection('conversations').doc(conversationId).update({
      'lastMessage': text.isNotEmpty ? text : '📷 Shared a photo',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'isRead': false,
    });

    // Trigger provider auto-reply
    _scheduleProviderReply(conversationId, text, imageUrl);
  }

  void _scheduleProviderReply(String conversationId, String userText, String? imageUrl) {
    // Show typing indicator after delay
    Timer(const Duration(milliseconds: 600), () {
      final currentTyping = Map<String, bool>.from(typingStatusNotifier.value);
      currentTyping[conversationId] = true;
      typingStatusNotifier.value = currentTyping;
    });

    // Provider reply after typing interval
    Timer(const Duration(milliseconds: 2200), () async {
      final currentTyping = Map<String, bool>.from(typingStatusNotifier.value);
      currentTyping[conversationId] = false;
      typingStatusNotifier.value = currentTyping;

      final replyText = _generateSmartReply(userText, imageUrl);

      await _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .add({
        'senderId': 'provider',
        'text': replyText,
        'timestamp': FieldValue.serverTimestamp(),
        'isMe': false,
      });

      // Update conversation
      await _firestore.collection('conversations').doc(conversationId).update({
        'lastMessage': replyText,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'isRead': false,
      });

      // Register notification
      final conv = await _getConversation(conversationId);
      if (conv != null) {
        NotificationService().addNotification(
          title: 'New message from ${conv.providerName}',
          body: replyText,
          type: NotificationType.booking,
          actionRoute: 'chat',
          actionPayload: conversationId,
        );
      }
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

  Future<Conversation> _getConversation(String conversationId) async {
    final doc = await _firestore.collection('conversations').doc(conversationId).get();
    if (doc.exists) {
      return Conversation.fromFirestore(doc);
    }
    return null;
  }

  // Get or create conversation for provider
  Future<Conversation> getOrCreateConversationForProvider(Provider provider) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    // Check existing conversation
    final existing = await _firestore
        .collection('conversations')
        .where('participants', arrayContains: userId)
        .where('participants', arrayContains: provider.id)
        .get();

    if (existing.docs.isNotEmpty) {
      return Conversation.fromFirestore(existing.docs.first);
    }

    // Create new conversation
    final convRef = await _firestore.collection('conversations').add({
      'participants': [userId, provider.id],
      'participantNames': [
        userId.split('@').first,
        provider.name,
      ],
      'participantImages': ['', provider.imageUrl],
      'lastMessage': "Hello! Let me know how I can help with your service.",
      'lastMessageTime': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
    });

    final conv = Conversation.fromFirestore(convRef);
    
    // Seed initial message
    await _firestore
        .collection('conversations')
        .doc(conv.id)
        .collection('messages')
        .add({
      'senderId': 'provider',
      'text': "Hello! Thanks for viewing my profile. Feel free to ask any questions about my services or availability.",
      'timestamp': FieldValue.serverTimestamp(),
      'isMe': false,
    });

    return conv;
  }

  Future<void> markAsRead(String conversationId) async {
    await _firestore.collection('conversations').doc(conversationId).update({
      'isRead': true,
    });
  }

  Future<void> deleteConversation(String conversationId) async {
    await _firestore.collection('conversations').doc(conversationId).delete();
    await _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  // Update conversation last message
  Future<void> _updateConversationLastMessage({
    required String conversationId,
    required String lastMessage,
    required String time,
    required bool isUnread,
  }) async {
    await _firestore.collection('conversations').doc(conversationId).update({
      'lastMessage': lastMessage,
      'lastMessageTime': isUnread ? FieldValue.serverTimestamp() : null,
      'isUnread': isUnread,
    });
  }

  // Seed default messages (for new conversations)
  Future<void> _seedDefaultMessages(String conversationId) async {
    final messages = [
      Message(
        id: 'msg_welcome_$conversationId',
        senderId: 'provider',
        text: "Hello! I've received your request.",
        timestamp: FieldValue.serverTimestamp(),
        isMe: false,
      ),
      Message(
        id: 'msg_user_1',
        senderId: 'me',
        text: "Hi! Yes, it's getting quite messy. How soon can you be here?",
        timestamp: FieldValue.serverTimestamp(),
        isMe: true,
      ),
    ];

    for (var message in messages) {
      await _firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .add(message.toFirestore());
    }
  }

  // Message methods
  Stream<List<Message>> messagesStream(String conversationId) {
    return _messagesStream(conversationId).map((snapshot) {
      return snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    });
  }

  Future<Message> sendMessageWithId({
    required String conversationId,
    required String text,
    String? imageUrl,
  }) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    final messageRef = await _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .add({
      'senderId': userId,
      'text': text,
      'imageUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
      'isMe': true,
    });

    final doc = await messageRef.get();
    return Message.fromFirestore(doc);
  }

  Future<List<Message>> getMessages(String conversationId) async {
    final snapshot = await _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .get();

    return snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList();
  }
}