import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import '../models/provider.dart';
import '../models/app_notification.dart';
import 'notification_service.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  final ValueNotifier<List<Conversation>> conversationsNotifier =
      ValueNotifier<List<Conversation>>([]);
  final ValueNotifier<int> unreadCountNotifier = ValueNotifier<int>(0);
  final ValueNotifier<Map<String, bool>> typingStatusNotifier =
      ValueNotifier<Map<String, bool>>({});
  final Map<String, ValueNotifier<List<Message>>>
  _conversationMessagesNotifiers = {};
  final Set<String> _listeningConversations = {};

  // Lazily resolved so the service can be constructed before Firebase is ready
  // (for example in unit/widget tests).
  FirebaseFirestore? _firestoreInstance;
  FirebaseAuth? _authInstance;

  FirebaseFirestore get _firestore =>
      _firestoreInstance ??= FirebaseFirestore.instance;
  FirebaseAuth get _auth => _authInstance ??= FirebaseAuth.instance;

  bool _initialized = false;
  bool _localMode = false;
  final List<Conversation> _localConversations = [];
  final Map<String, List<Message>> _localMessages = {};

  Future<void> init({bool isAdmin = false}) async {
    if (_initialized) return;

    // When Firebase has not been initialized (e.g. in tests or an offline
    // preview build), fall back to an in-memory demo dataset.
    if (Firebase.apps.isEmpty) {
      _enableLocalMode();
      return;
    }

    try {
      await _initializeFirestore();
      _initialized = true;
    } catch (_) {
      _enableLocalMode();
    }
  }

  void _enableLocalMode() {
    _localMode = true;
    _seedLocalData();
    _initialized = true;
  }

  void _seedLocalData() {
    final now = DateTime.now();
    _localConversations
      ..clear()
      ..addAll([
        Conversation(
          id: 'conv_local_1',
          providerName: 'TechFix Mobile',
          providerIcon: 'smartphone',
          isOnline: true,
          isUnread: true,
          participants: const ['me', 'provider_1'],
          participantNames: const ['You', 'TechFix Mobile'],
          participantImages: const ['', ''],
          lastMessage: 'I am on my way!',
          time: 'Now',
          lastMessageTime: Timestamp.fromDate(
            now.subtract(const Duration(minutes: 2)),
          ),
          createdAt: Timestamp.fromDate(now.subtract(const Duration(days: 1))),
        ),
        Conversation(
          id: 'conv_local_2',
          providerName: 'John D.',
          providerIcon: 'content_cut',
          isUnread: false,
          participants: const ['me', 'provider_2'],
          participantNames: const ['You', 'John D.'],
          participantImages: const ['', ''],
          lastMessage: 'See you at 10 AM.',
          time: '10:00 AM',
          lastMessageTime: Timestamp.fromDate(
            now.subtract(const Duration(hours: 3)),
          ),
          createdAt: Timestamp.fromDate(now.subtract(const Duration(days: 3))),
        ),
      ]);

    _localMessages
      ..clear()
      ..['conv_local_1'] = [
        Message(
          id: 'local_msg_1',
          senderId: 'provider_1',
          text: 'Hello! I have received your request.',
          timestamp: now.subtract(const Duration(minutes: 15)),
          isMe: false,
        ),
        Message(
          id: 'local_msg_2',
          senderId: 'me',
          text: 'Great, how soon can you arrive?',
          timestamp: now.subtract(const Duration(minutes: 10)),
          isMe: true,
        ),
        Message(
          id: 'local_msg_3',
          senderId: 'provider_1',
          text: 'I am on my way!',
          timestamp: now.subtract(const Duration(minutes: 2)),
          isMe: false,
        ),
      ]
      ..['conv_local_2'] = [
        Message(
          id: 'local_msg_4',
          senderId: 'provider_2',
          text: 'See you at 10 AM.',
          timestamp: now.subtract(const Duration(hours: 3)),
          isMe: false,
        ),
      ];

    conversationsNotifier.value = List<Conversation>.from(_localConversations);
    _updateUnreadCount(_localConversations);
  }

  void _refreshLocalConversations() {
    conversationsNotifier.value = List<Conversation>.from(_localConversations);
    _updateUnreadCount(_localConversations);
  }

  void _notifyLocalMessages(String conversationId) {
    final notifier = _conversationMessagesNotifiers[conversationId];
    if (notifier == null) return;
    final messages = List<Message>.from(
      _localMessages[conversationId] ?? const [],
    )..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    notifier.value = messages;
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
    if (_localMode) {
      for (final conversation in _localConversations) {
        if (conversation.participants.contains(participantId)) {
          return conversation;
        }
      }

      final conversation = Conversation(
        id: 'conv_${participantId}_${DateTime.now().millisecondsSinceEpoch}',
        providerName: participantName,
        avatarUrl: participantImageUrl,
        participants: ['me', participantId],
        participantNames: ['You', participantName],
        participantImages: ['', participantImageUrl],
        lastMessage: '',
        time: 'Now',
        lastMessageTime: Timestamp.now(),
        createdAt: Timestamp.now(),
      );
      _localConversations.insert(0, conversation);
      _localMessages[conversation.id] = [];
      _refreshLocalConversations();
      return conversation;
    }

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
      'isUnread': false,
    });

    final doc = await convRef.get();
    return Conversation.fromFirestore(doc);
  }

  Future<Message> sendMessage({
    required String conversationId,
    required String text,
    String? imageUrl,
  }) async {
    if (_localMode) {
      final message = Message(
        id: 'local_msg_${DateTime.now().microsecondsSinceEpoch}',
        senderId: 'me',
        text: text,
        timestamp: DateTime.now(),
        isMe: true,
        imageUrl: imageUrl,
      );
      _localMessages.putIfAbsent(conversationId, () => []).add(message);

      final index = _localConversations.indexWhere(
        (c) => c.id == conversationId,
      );
      if (index != -1) {
        _localConversations[index] = _localConversations[index].copyWith(
          lastMessage: text.isNotEmpty ? text : '📷 Shared a photo',
          time: 'Now',
          lastMessageTime: Timestamp.now(),
          isUnread: false,
        );
        _refreshLocalConversations();
      }

      _notifyLocalMessages(conversationId);
      return message;
    }

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
      'isUnread': false,
    });

    // Trigger provider auto-reply
    _scheduleProviderReply(conversationId, text, imageUrl);

    final doc = await messageRef.get();
    return Message.fromFirestore(doc);
  }

  void _scheduleProviderReply(
    String conversationId,
    String userText,
    String? imageUrl,
  ) {
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
        'isUnread': true,
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
    if (lower.contains('where') ||
        lower.contains('arrive') ||
        lower.contains('time') ||
        lower.contains('when') ||
        lower.contains('soon')) {
      return "I'm finishing up my previous slot nearby and will be with you in about 10-15 minutes!";
    }
    if (lower.contains('price') ||
        lower.contains('cost') ||
        lower.contains('charge') ||
        lower.contains('how much') ||
        lower.contains('cash') ||
        lower.contains('transfer')) {
      return "My pricing is completely transparent as listed on my SwiftServe profile. Cash or in-app transfer both work great!";
    }
    if (lower.contains('hello') ||
        lower.contains('hi') ||
        lower.contains('hey')) {
      return "Hello! Thanks for reaching out. Please let me know any specific instructions for the location.";
    }
    if (lower.contains('leak') ||
        lower.contains('pipe') ||
        lower.contains('water') ||
        lower.contains('broken') ||
        lower.contains('fix')) {
      return "Understood. Please keep the water main valve shut if possible, I'll attend to it immediately upon arrival.";
    }
    if (lower.contains('thank') ||
        lower.contains('ok') ||
        lower.contains('alright') ||
        lower.contains('cool')) {
      return "You're very welcome! See you shortly.";
    }

    return "Got your message! I've noted down the details and I'm on it.";
  }

  Future<Conversation?> _getConversation(String conversationId) async {
    if (_localMode) {
      for (final conversation in _localConversations) {
        if (conversation.id == conversationId) return conversation;
      }
      return null;
    }

    final doc = await _firestore
        .collection('conversations')
        .doc(conversationId)
        .get();
    if (doc.exists) {
      return Conversation.fromFirestore(doc);
    }
    return null;
  }

  // Get or create conversation for provider
  Future<Conversation> getOrCreateConversationForProvider(
    Provider provider,
  ) async {
    if (_localMode) {
      for (final conversation in _localConversations) {
        if (conversation.participants.contains(provider.id)) {
          return conversation;
        }
      }

      final conversation = Conversation(
        id: 'conv_${provider.id}_${DateTime.now().millisecondsSinceEpoch}',
        providerName: provider.name,
        avatarUrl: provider.imageUrl,
        isOnline: true,
        isUnread: false,
        participants: ['me', provider.id],
        participantNames: ['You', provider.name],
        participantImages: ['', provider.imageUrl],
        lastMessage: 'Hello! Let me know how I can help with your service.',
        time: 'Now',
        lastMessageTime: Timestamp.now(),
        createdAt: Timestamp.now(),
      );
      _localConversations.insert(0, conversation);
      _localMessages[conversation.id] = [
        Message(
          id: 'local_welcome_${provider.id}',
          senderId: 'provider',
          text:
              'Hello! Thanks for viewing my profile. Feel free to ask any questions about my services or availability.',
          timestamp: DateTime.now(),
          isMe: false,
        ),
      ];
      _refreshLocalConversations();
      return conversation;
    }

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
      'participantNames': [userId.split('@').first, provider.name],
      'participantImages': ['', provider.imageUrl],
      'lastMessage': "Hello! Let me know how I can help with your service.",
      'lastMessageTime': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
      'isUnread': false,
    });

    final doc = await convRef.get();
    final conv = Conversation.fromFirestore(doc);

    // Seed initial message
    await _firestore
        .collection('conversations')
        .doc(conv.id)
        .collection('messages')
        .add({
          'senderId': 'provider',
          'text':
              "Hello! Thanks for viewing my profile. Feel free to ask any questions about my services or availability.",
          'timestamp': FieldValue.serverTimestamp(),
          'isMe': false,
        });

    return conv;
  }

  Future<void> markAsRead(String conversationId) async {
    if (_localMode) {
      final index = _localConversations.indexWhere(
        (c) => c.id == conversationId,
      );
      if (index != -1) {
        _localConversations[index] = _localConversations[index].copyWith(
          isUnread: false,
        );
        _refreshLocalConversations();
      }
      return;
    }

    await _firestore.collection('conversations').doc(conversationId).update({
      'isUnread': false,
    });
  }

  Future<void> deleteConversation(String conversationId) async {
    if (_localMode) {
      _localConversations.removeWhere((c) => c.id == conversationId);
      _localMessages.remove(conversationId);
      _conversationMessagesNotifiers.remove(conversationId)?.dispose();
      _listeningConversations.remove(conversationId);
      _refreshLocalConversations();
      return;
    }

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

  // Message methods
  Stream<List<Message>> messagesStream(String conversationId) {
    if (_localMode) {
      final messages = List<Message>.from(
        _localMessages[conversationId] ?? const [],
      )..sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return Stream<List<Message>>.value(messages);
    }

    return _messagesStream(conversationId).map((snapshot) {
      return snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    });
  }

  /// Returns a live notifier of messages for a conversation.
  ///
  /// The underlying Firestore listener is only attached once per conversation.
  ValueListenable<List<Message>> getMessageNotifier(String conversationId) {
    final notifier = _conversationMessagesNotifiers.putIfAbsent(
      conversationId,
      () => ValueNotifier<List<Message>>([]),
    );

    if (_localMode) {
      notifier.value = List<Message>.from(
        _localMessages[conversationId] ?? const [],
      )..sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return notifier;
    }

    if (_listeningConversations.add(conversationId)) {
      messagesStream(conversationId).listen((messages) {
        notifier.value = messages;
      });
    }

    return notifier;
  }

  Future<Message> sendMessageWithId({
    required String conversationId,
    required String text,
    String? imageUrl,
  }) async {
    if (_localMode) {
      return sendMessage(
        conversationId: conversationId,
        text: text,
        imageUrl: imageUrl,
      );
    }

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
    if (_localMode) {
      return List<Message>.from(_localMessages[conversationId] ?? const [])
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    }

    final snapshot = await _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .get();

    return snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList();
  }
}
