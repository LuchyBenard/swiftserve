import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import '../services/chat_service.dart';
import '../services/address_service.dart';
import '../services/storage_service.dart';

class ChatPage extends StatefulWidget {
  final Conversation conversation;

  const ChatPage({super.key, required this.conversation});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  final ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();
    _chatService.init().then((_) {
      _chatService.markAsRead(widget.conversation.id);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 150), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage([String? customText, String? imageUrl]) async {
    final text = customText ?? _messageController.text.trim();
    if (text.isEmpty && imageUrl == null) return;

    if (customText == null) {
      _messageController.clear();
    }

    await _chatService.sendMessage(
      conversationId: widget.conversation.id,
      text: text,
      imageUrl: imageUrl,
    );

    _scrollToBottom();
  }

  Future<void> _handleAttachImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      final url = await StorageService().uploadFile(
        File(image.path),
        folder: 'chat/${widget.conversation.id}',
      );
      await _sendMessage('Attached photo for reference', url);
    }
  }

  void _showAttachmentOptions(Color neonGreen) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141414),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'QUICK ACTIONS',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.grey[400],
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionOption(
                    icon: Icons.photo_camera,
                    label: 'Camera',
                    onTap: () async {
                      Navigator.pop(ctx);
                      final XFile? photo = await _imagePicker.pickImage(
                        source: ImageSource.camera,
                      );
                      if (photo != null) {
                        final url = await StorageService().uploadFile(
                          File(photo.path),
                          folder: 'chat/${widget.conversation.id}',
                        );
                        await _sendMessage('Captured photo', url);
                      }
                    },
                    neonGreen: neonGreen,
                  ),
                  _buildActionOption(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: () {
                      Navigator.pop(ctx);
                      _handleAttachImage();
                    },
                    neonGreen: neonGreen,
                  ),
                  _buildActionOption(
                    icon: Icons.location_on,
                    label: 'Location',
                    onTap: () {
                      Navigator.pop(ctx);
                      final activeAddr =
                          AddressService()
                              .selectedAddressNotifier
                              .value
                              ?.addressLine ??
                          'Independence Layout, Enugu';
                      _sendMessage('📍 Here is my location: $activeAddr');
                    },
                    neonGreen: neonGreen,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Divider(color: Colors.white.withValues(alpha: 0.1)),
              const SizedBox(height: 12),
              Text(
                'QUICK REPLIES',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.grey[500],
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildQuickReplyChip('Are you on your way?', neonGreen, ctx),
                  _buildQuickReplyChip("I'm waiting outside", neonGreen, ctx),
                  _buildQuickReplyChip('Please call when here', neonGreen, ctx),
                  _buildQuickReplyChip(
                    'Can I pay with transfer?',
                    neonGreen,
                    ctx,
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickReplyChip(String text, Color neonGreen, BuildContext ctx) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(ctx);
        _sendMessage(text);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF222222),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
        ),
        child: Text(
          text,
          style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildActionOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color neonGreen,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: neonGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: neonGreen.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: neonGreen, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showCallDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF141414),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.phone_in_talk, color: Color(0xFF25F46A)),
            const SizedBox(width: 12),
            Text(
              'Call Provider',
              style: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'Connect directly with ${widget.conversation.providerName} for real-time voice instructions.',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: GoogleFonts.spaceGrotesk(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final Uri launchUri = Uri(scheme: 'tel', path: '+2348001234567');
              if (await canLaunchUrl(launchUri)) {
                await launchUrl(launchUri);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25F46A),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Dial Now',
              style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePreview(String imageUrl) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: imageUrl.startsWith('http')
                  ? Image.network(imageUrl, fit: BoxFit.contain)
                  : Image.file(File(imageUrl), fit: BoxFit.contain),
            ),
            IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.black54,
                child: Icon(Icons.close, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const neonGreen = Color(0xFF25F46A);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Glow
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(37, 244, 106, 0.05),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(neonGreen),
                Expanded(
                  child: ValueListenableBuilder<List<Message>>(
                    valueListenable: _chatService.getMessageNotifier(
                      widget.conversation.id,
                    ),
                    builder: (context, messages, _) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => _scrollToBottom(),
                      );

                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(20),
                        itemCount:
                            messages.length + 1, // +1 for typing indicator
                        itemBuilder: (context, index) {
                          if (index == messages.length) {
                            return _buildTypingIndicator(neonGreen);
                          }
                          final message = messages[index];
                          return _buildMessageBubble(message, neonGreen);
                        },
                      );
                    },
                  ),
                ),
                _buildInputArea(neonGreen),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(Color neonGreen) {
    return ValueListenableBuilder<Map<String, bool>>(
      valueListenable: _chatService.typingStatusNotifier,
      builder: (context, statusMap, _) {
        final isTyping = statusMap[widget.conversation.id] ?? false;
        if (!isTyping) return const SizedBox.shrink();

        return Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF141414),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: neonGreen.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${widget.conversation.providerName} is typing',
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(neonGreen),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(Color neonGreen) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.conversation.providerName,
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.conversation.isOnline) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: neonGreen,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: neonGreen.withValues(alpha: 0.5),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.conversation.isOnline ? 'ONLINE' : 'OFFLINE',
                      style: GoogleFonts.spaceGrotesk(
                        color: widget.conversation.isOnline
                            ? neonGreen
                            : Colors.grey,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.phone_outlined,
              color: Colors.white,
              size: 22,
            ),
            onPressed: _showCallDialog,
          ),
          const SizedBox(width: 4),
          _buildAvatar(widget.conversation),
        ],
      ),
    );
  }

  Widget _buildAvatar(Conversation c) {
    if (c.avatarUrl.isNotEmpty) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF25F46A).withValues(alpha: 0.2),
            width: 1,
          ),
          image: DecorationImage(
            image: NetworkImage(c.avatarUrl),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      IconData icon = Icons.person;
      if (c.providerIcon == 'plumbing') icon = Icons.plumbing;
      if (c.providerIcon == 'cleaning_services') icon = Icons.cleaning_services;

      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Icon(icon, color: Colors.grey[400], size: 18),
      );
    }
  }

  Widget _buildMessageBubble(Message message, Color neonGreen) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: message.isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: EdgeInsets.symmetric(
              horizontal: message.imageUrl != null ? 8 : 16,
              vertical: message.imageUrl != null ? 8 : 12,
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: message.isMe
                  ? const Color(0xFF1A1A1A)
                  : neonGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(message.isMe ? 20 : 4),
                bottomRight: Radius.circular(message.isMe ? 4 : 20),
              ),
              border: message.isMe
                  ? null
                  : Border.all(color: neonGreen.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.imageUrl != null)
                  GestureDetector(
                    onTap: () => _showImagePreview(message.imageUrl!),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: message.imageUrl!.startsWith('http')
                            ? Image.network(
                                message.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => Container(
                                  height: 150,
                                  width: double.infinity,
                                  color: Colors.grey[900],
                                  child: const Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : Image.file(
                                File(message.imageUrl!),
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => Container(
                                  height: 150,
                                  width: double.infinity,
                                  color: Colors.grey[900],
                                  child: const Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                if (message.text.isNotEmpty)
                  Text(
                    message.text,
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 4, right: 4),
            child: Text(
              _formatTime(message.timestamp),
              style: TextStyle(color: Colors.grey[600], fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    return "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  Widget _buildInputArea(Color neonGreen) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF121212),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, color: Colors.white, size: 24),
              onPressed: () => _showAttachmentOptions(neonGreen),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: TextField(
                controller: _messageController,
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: GoogleFonts.spaceGrotesk(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => _sendMessage(),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: neonGreen,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: neonGreen.withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.black,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
