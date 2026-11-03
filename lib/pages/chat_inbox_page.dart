import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/conversation.dart';
import '../models/provider.dart';
import '../services/chat_service.dart';
import 'chat_page.dart';

class ChatInboxPage extends StatefulWidget {
  const ChatInboxPage({super.key});

  @override
  State<ChatInboxPage> createState() => _ChatInboxPageState();
}

class _ChatInboxPageState extends State<ChatInboxPage> {
  final ChatService _chatService = ChatService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _chatService.init();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildSearchBar(),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ValueListenableBuilder<List<Conversation>>(
              valueListenable: _chatService.conversationsNotifier,
              builder: (context, conversations, _) {
                final filtered = conversations.where((c) {
                  if (_searchQuery.isEmpty) return true;
                  return c.providerName.toLowerCase().contains(_searchQuery) ||
                      c.lastMessage.toLowerCase().contains(_searchQuery);
                }).toList();

                if (filtered.isEmpty) {
                  return _buildEmptyState();
                }

                return Column(
                  children: filtered.map((c) => _buildDismissibleConversationItem(c)).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Messages',
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              // New Chat Icon
              GestureDetector(
                onTap: _showNewChatSheet,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF25F46A).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF25F46A).withValues(alpha: 0.2)),
                  ),
                  child: const Icon(Icons.add, color: Color(0xFF25F46A), size: 24),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color.fromRGBO(37, 244, 106, 0.2), width: 2),
                ),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCqaZ7wk8boFIodQC_72x7gFRiF-KA6YLJuS5oG787ow5E6cLDav6l_BvN9b8MFowza2zKonigLZuY4910ShpjHQLW9A7Fj_7k6AMzI0JNMBa1EOrExgnZr_W-t9OZWd02hW3qIm5zf3KHs_Opa9s_8_0MeRGhiLbBxE2owIqQY84oOJOEsTnjK3hkyVvq9ZcrEhEgDCgilg-b8o7f2kH-IhMntmDQcIhOIU54NJFLtCj-XVoZVmtQoEdxEm2dI5zYAJ18MQ_JQ2d6b',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.1)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(Icons.search, color: Colors.grey[600], size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.spaceGrotesk(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search conversations...',
                hintStyle: GoogleFonts.spaceGrotesk(color: Colors.grey[600]),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: Icon(Icons.close, color: Colors.grey[500], size: 20),
              onPressed: () => _searchController.clear(),
            ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.only(top: 48),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF25F46A).withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF25F46A), size: 40),
          ),
          const SizedBox(height: 20),
          Text(
            _searchQuery.isNotEmpty ? 'No conversations found' : 'No messages yet',
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? 'Try searching for another keyword or provider name.'
                : 'Connect directly with verified service professionals in real-time.',
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceGrotesk(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
          if (_searchQuery.isNotEmpty) ...[
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () => _searchController.clear(),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF25F46A)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Text(
                'Clear Search',
                style: GoogleFonts.spaceGrotesk(color: const Color(0xFF25F46A)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDismissibleConversationItem(Conversation conversation) {
    return Dismissible(
      key: Key('conv_${conversation.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Colors.redAccent.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(Icons.delete_outline, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Text(
              'Delete',
              style: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (_) async {
        await _chatService.deleteConversation(conversation.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Conversation with ${conversation.providerName} removed',
                style: GoogleFonts.spaceGrotesk(),
              ),
              backgroundColor: const Color(0xFF1E1E1E),
            ),
          );
        }
      },
      child: _buildConversationItem(conversation),
    );
  }

  Widget _buildConversationItem(Conversation conversation) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(conversation: conversation),
            ),
          );
        },
        borderRadius: BorderRadius.circular(24),
        hoverColor: const Color(0xFF25F46A).withValues(alpha: 0.05),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar with Online/Unread Dot
              Stack(
                children: [
                  _buildAvatar(conversation),
                  if (conversation.isUnread)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFF25F46A),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black, width: 3),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFF25F46A),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            conversation.providerName,
                            style: GoogleFonts.spaceGrotesk(
                              color: conversation.isUnread ? Colors.white : Colors.grey[300],
                              fontSize: 16,
                              fontWeight: conversation.isUnread ? FontWeight.bold : FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          conversation.time,
                          style: GoogleFonts.spaceGrotesk(
                            color: conversation.isUnread ? const Color(0xFF25F46A) : Colors.grey[600],
                            fontSize: 11,
                            fontWeight: conversation.isUnread ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      conversation.lastMessage,
                      style: GoogleFonts.spaceGrotesk(
                        color: conversation.isUnread ? Colors.grey[300] : Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(Conversation c) {
    if (c.avatarUrl.isNotEmpty) {
      return Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(c.avatarUrl),
            fit: BoxFit.cover,
          ),
          border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.1)),
        ),
      );
    } else {
      IconData icon = Icons.person;
      if (c.providerIcon == 'plumbing') icon = Icons.plumbing;
      if (c.providerIcon == 'cleaning_services') icon = Icons.cleaning_services;
      if (c.providerIcon == 'electrical_services') icon = Icons.electrical_services;

      return Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          shape: BoxShape.circle,
          border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.1)),
        ),
        child: Icon(icon, color: Colors.grey[400], size: 24),
      );
    }
  }

  void _showNewChatSheet() {
    final availableProviders = [
      Provider(
        id: 'techfix',
        name: 'TechFix Mobile',
        role: 'Phone Technician',
        rating: 4.95,
        reviewsCount: 85,
        distance: '1.2 mi',
        priceStart: 85.0,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCFQ7PW4mJq0pCsms1S5jz6jktvhtIvJQ9pCJONsOidljGYa7n-oOe3IfKlHfO8bAO2UdEGUQFcIaTidjxESclQcNwqAVjyIKdxjfQkF5l0qxfkG5_GnqCv55JJpxEb5piWICYx5fyA3b8zNi6xi5Sn8JYfwGGQEgmJW_hQWFG2K685urWWLtHgOjZkVBxQ9xxK4TOrOfOo619efYpLS_RSNTrKfwdGF9_rsCbFrv3wy1fv9nPbKlWmBLHpJsNhKJmqCGzElH2jR2uT',
        about: 'Certified mobile technician specializing in micro-soldering and screen replacements.',
        services: ['Screen Repair', 'Battery Replacement'],
      ),
      Provider(
        id: 'barber_alex',
        name: 'Alex the Barber',
        role: 'Master Barber',
        rating: 4.98,
        reviewsCount: 142,
        distance: '0.8 mi',
        priceStart: 35.0,
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAQY-wJQBD18t4GYQjf_DFHRKKTDMbwPTEdf3y0G3_pnsISu96W29vq7mSX_7ZURbByCaRcP_rwjXjYO-jZ39d-I7PFbj8H7q9lk0z6UDFMsHpTKJPX0LUYEk6HZQPzr9xvCAnMpI8GxGKxTjSZNMYqcmy1Eh5VNKh3loa7SWv2WqNT7MEFGNFATRVabclMw7Qq5uPMRZcpobPAT3CZrA8ovg5y72uAKbEJ2BZxTDmO-i1v2g7Aq-imn2ikZzb3sMuRdbeEL2aXU0qS',
        about: 'Premium haircutting and beard grooming services directly to your doorstep.',
        services: ['Haircut', 'Beard Trim'],
      ),
      Provider(
        id: 'plumber_mike',
        name: "Mike's Plumbing",
        role: 'Licensed Plumber',
        rating: 4.85,
        reviewsCount: 94,
        distance: '2.4 mi',
        priceStart: 60.0,
        imageUrl: '',
        about: 'Emergency plumbing repairs, leak fixes, and installation.',
        services: ['Pipe Leak Repair', 'Drain Cleaning'],
      ),
      Provider(
        id: 'sparkle_clean',
        name: 'Sparkle Clean Co.',
        role: 'Deep Cleaning Specialist',
        rating: 4.79,
        reviewsCount: 63,
        distance: '3.1 mi',
        priceStart: 40.0,
        imageUrl: '',
        about: 'Residential and commercial deep cleaning and sanitization.',
        services: ['Home Deep Cleaning', 'Office Sanitization'],
      ),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141414),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(sheetContext).padding.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Start a Conversation',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Select a verified artisan or provider to message directly:',
                style: GoogleFonts.spaceGrotesk(color: Colors.grey[400], fontSize: 13),
              ),
              const SizedBox(height: 16),
              ...availableProviders.map((p) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF25F46A).withValues(alpha: 0.15),
                    backgroundImage: p.imageUrl.isNotEmpty ? NetworkImage(p.imageUrl) : null,
                    child: p.imageUrl.isEmpty
                        ? const Icon(Icons.person, color: Color(0xFF25F46A))
                        : null,
                  ),
                  title: Text(
                    p.name,
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${p.role} • ★ ${p.rating}',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF25F46A).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.chat_bubble_outline, color: Color(0xFF25F46A), size: 18),
                  ),
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    final conv = await _chatService.getOrCreateConversationForProvider(p);
                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(conversation: conv),
                        ),
                      );
                    }
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
