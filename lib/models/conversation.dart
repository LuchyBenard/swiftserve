import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  final String id;
  final String providerName;
  final String? avatarUrl;
  final String? providerIcon;
  final bool isOnline;
  final bool isUnread;
  final List<String> participants;
  final List<String> participantNames;
  final List<String> participantImages;
  final String lastMessage;
  final Timestamp? lastMessageTime;
  final Timestamp? createdAt;

  Conversation({
    required this.id,
    required this.providerName,
    this.avatarUrl,
    this.providerIcon,
    required this.isOnline,
    required this.isUnread,
    required this.participants,
    required this.participantNames,
    required this.participantImages,
    required this.lastMessage,
    this.lastMessageTime,
    this.createdAt,
  });

  factory Conversation.fromFirestore(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Conversation(
      id: data['id'] ?? snapshot.id,
      providerName: data['providerName'] ?? '',
      avatarUrl: data['avatarUrl'],
      providerIcon: data['providerIcon'],
      isOnline: data['isOnline'] ?? false,
      isUnread: data['isUnread'] ?? false,
      participants: List<String>.from(data['participants'] ?? []),
      participantNames: List<String>.from(data['participantNames'] ?? []),
      participantImages: List<String>.from(data['participantImages'] ?? []),
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: data['lastMessageTime'] as Timestamp?,
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
      'lastMessageTime': lastMessageTime,
      'createdAt': createdAt,
    };
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
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}