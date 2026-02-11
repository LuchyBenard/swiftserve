import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/conversation.dart';
import 'chat_page.dart';

class ChatInboxPage extends StatefulWidget {
  const ChatInboxPage({super.key});

  @override
  State<ChatInboxPage> createState() => _ChatInboxPageState();
}

class _ChatInboxPageState extends State<ChatInboxPage> {
  final List<Conversation> _conversations = [
    Conversation(
      id: '1',
      providerName: 'TechFix Mobile',
      lastMessage: "I've arrived at your location, please come out...",
      time: '2:45 PM',
      avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCFQ7PW4mJq0pCsms1S5jz6jktvhtIvJQ9pCJONsOidljGYa7n-oOe3IfKlHfO8bAO2UdEGUQFcIaTidjxESclQcNwqAVjyIKdxjfQkF5l0qxfkG5_GnqCv55JJpxEb5piWICYx5fyA3b8zNi6xi5Sn8JYfwGGQEgmJW_hQWFG2K685urWWLtHgOjZkVBxQ9xxK4TOrOfOo619efYpLS_RSNTrKfwdGF9_rsCbFrv3wy1fv9nPbKlWmBLHpJsNhKJmqCGzElH2jR2uT',
      isOnline: true,
      isUnread: true,
    ),
    Conversation(
      id: '2',
      providerName: 'Alex the Barber',
      lastMessage: 'Thanks for the booking! See you tomorrow at 10.',
      time: '11:20 AM',
      avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAQY-wJQBD18t4GYQjf_DFHRKKTDMbwPTEdf3y0G3_pnsISu96W29vq7mSX_7ZURbByCaRcP_rwjXjYO-jZ39d-I7PFbj8H7q9lk0z6UDFMsHpTKJPX0LUYEk6HZQPzr9xvCAnMpI8GxGKxTjSZNMYqcmy1Eh5VNKh3loa7SWv2WqNT7MEFGNFATRVabclMw7Qq5uPMRZcpobPAT3CZrA8ovg5y72uAKbEJ2BZxTDmO-i1v2g7Aq-imn2ikZzb3sMuRdbeEL2aXU0qS',
      isOnline: false,
      isUnread: false,
    ),
    Conversation(
      id: '3',
      providerName: "Mike's Plumbing",
      lastMessage: 'The invoice has been sent to your email.',
      time: 'Yesterday',
      isOnline: true,
      isUnread: false, // In the design this actually looks unread? But text is white. Let's assume unread indicator is the green dot which is `isOnline`, but `isUnread` affects text color.
                       // Wait, looking at design:
                       // Top one: Name White, Time Green, Msg White. Green dot on avatar.
                       // Second: Name Grey, Time Grey, Msg Grey. No dot.
                       // Third: Name White, Time Green, Msg White. Green dot.
                       // Fourth: Name Grey, Time Grey, Msg Grey. No dot.
                       // Ah, usually green dot means Online. But maybe here it means Unread?
                       // The prompt says "features unread message indicators in neon green".
                       // And the HTML says `bg-primary border-4 border-black rounded-full shadow-[0_0_8px_#25f46a]` for the dot.
                       // And for the text: `text-primary text-[11px] font-semibold`.
                       // So let's map `isUnread` to the green styles.
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
            padding: const EdgeInsets.symmetric(horizontal: 16), // List has own padding
            child: Column(
              children: _conversations.map((c) => _buildConversationItem(c)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 24), // Matches top padding roughly
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
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color.fromRGBO(37, 244, 106, 0.2), width: 2),
            ),
            child: const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuCqaZ7wk8boFIodQC_72x7gFRiF-KA6YLJuS5oG787ow5E6cLDav6l_BvN9b8MFowza2zKonigLZuY4910ShpjHQLW9A7Fj_7k6AMzI0JNMBa1EOrExgnZr_W-t9OZWd02hW3qIm5zf3KHs_Opa9s_8_0MeRGhiLbBxE2owIqQY84oOJOEsTnjK3hkyVvq9ZcrEhEgDCgilg-b8o7f2kH-IhMntmDQcIhOIU54NJFLtCj-XVoZVmtQoEdxEm2dI5zYAJ18MQ_JQ2d6b'),
            ),
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
              style: GoogleFonts.spaceGrotesk(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search conversations...',
                hintStyle: GoogleFonts.spaceGrotesk(color: Colors.grey[600]),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
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
        hoverColor: const Color(0xFF25F46A).withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar with Online/Unread Dot
              Stack(
                children: [
                  _buildAvatar(conversation),
                  if (conversation.isUnread) // HTML implies the green dot is prominent on "unread" looking items
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
}
