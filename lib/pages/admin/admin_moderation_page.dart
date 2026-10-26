import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminModerationPage extends StatefulWidget {
  const AdminModerationPage({super.key});

  @override
  State<AdminModerationPage> createState() => _AdminModerationPageState();
}

class _AdminModerationPageState extends State<AdminModerationPage> {
  bool _showActionLog = false;
  final Set<String> _revealedImages = {};

  final List<Map<String, dynamic>> _moderationItems = [
    {
      'id': '1',
      'username': '@j_smith_22',
      'type': 'CUST',
      'reason': 'Harassment',
      'time': '2m ago',
      'severity': 'high',
      'content': "This service was absolutely terrible. The technician is a complete fraud and should be banned from the app immediately. Don't trust anyone on this platform, it's all a scam! #scam #fake",
      'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCoFmugeTdDEUXEqSjqp6m0Uo0k9V3-xDb8m--qkvtgpcm6EOKcKEW4o9FEgH93558iNqaL8Ul_NkNRinOQals62yIZIg4UE_1t8qreSp3Ekt8-7C3yIuYhvfqNKqJVS-Ex8cIiSISDB-O1aPOwyAVetlpLMXtZOOs1dJ7VhcTuyKebp9EVj-b0BqLLmRzmW337iFKNtvzz0XdgVcNSd4szTku9-0Z2Ae3UEaKLzOhLgSaza7qZxnOeI_CunqHAEKBiP8SgDWYYIBJg',
    },
    {
      'id': '2',
      'username': '@swift_plumber_x',
      'type': 'PRO',
      'reason': 'Graphic',
      'time': '15m ago',
      'severity': 'medium',
      'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuD7kfZ8pLZHnuuxpUNCLv4Ik-_AkurE-NK50GWGwx-puGYD85_bZph7b69OS__ek5MYa2r7T1ikPq5XN4UYWkz6qXZ8ktq_5_kGfFwKPjyBo1Kkt-tkLcfEh7DEhE5JAe0yQEdZO8-Uf7xXdTVssMd3FCd2WZIriEn1XjI2WKj4ypXtdx4LRuroHhU69pn7KLDnedJCLWxNoE2P36RM9G_jhuq6aZYpKzHNclZYycVoQlPVx5xMEBW1ajsZgwjDeM_ywBwgQaniMmTD',
      'caption': '"Look at this mess left by the previous guy..."',
      'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuB4nyGFdSDUBDJjP2ZQ17skl-mnG6pAA2KOiG5BeeHXLk4wj6fjk25wtlh9BjyU_OJqN8MZ93q_I4W5Q7HRFLZqXvqJzj4q0Me5az3slpzDNLxSauXf8gwnMR3oGrEe0yY6KVQolIVk9fisRcHilAbFBdBbSgCQko5Yt9w8xnwYkh_yCuq-iD0uhWTuUJtYP_kws3NzzWHqmUOBtnd23s3IFUYokNhYp58UNbd8-WUvsabaeoOp1F7Cq3zPZTYvVqnp1q0ZXBTX_QyP',
    },
    {
      'id': '3',
      'username': '@crypto_king_99',
      'type': 'CUST',
      'reason': 'Spam',
      'time': '45m ago',
      'severity': 'low',
      'content': "EARN \$5000 A DAY FROM HOME! Click the link in bio to start your journey now! 🚀🚀🚀",
      'isBot': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF25F46A);
    const backgroundDark = Color(0xFF050505);
    const surfaceDark = Color(0xFF121212);
    const dangerRed = Color(0xFFFF2A2A);

    return Scaffold(
      backgroundColor: backgroundDark,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildTopStatusBar(),
                _buildHeader(primaryGreen, dangerRed),
                Expanded(
                  child: _buildModerationQueue(primaryGreen, dangerRed, surfaceDark),
                ),
                _buildBottomNav(primaryGreen, backgroundDark),
              ],
            ),
          ),

          // Action Log Drawer
          if (_showActionLog)
            _buildActionLog(primaryGreen, surfaceDark),
        ],
      ),
    );
  }

  Widget _buildTopStatusBar() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('9:41', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
          Row(
            children: [
              const Icon(Icons.signal_cellular_alt, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              const Icon(Icons.wifi, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              const Icon(Icons.battery_full, color: Colors.white, size: 14),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Color primary, Color danger) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MODERATION',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: primary,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: primary.withValues(alpha: 0.5), blurRadius: 4, spreadRadius: 1)],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '12 ITEMS PENDING',
                    style: GoogleFonts.spaceGrotesk(color: primary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                ],
              ),
            ],
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.history, color: Colors.white),
                onPressed: () => setState(() => _showActionLog = true),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: danger,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModerationQueue(Color primary, Color danger, Color surface) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _moderationItems.length,
      itemBuilder: (context, index) {
        final item = _moderationItems[index];
        return _buildModerationCard(item, primary, danger, surface);
      },
    );
  }

  Widget _buildModerationCard(Map<String, dynamic> item, Color primary, Color danger, Color surface) {
    Color borderColor;
    if (item['severity'] == 'high') {
      borderColor = danger;
    } else if (item['severity'] == 'medium') {
      borderColor = Colors.yellow[700]!;
    } else {
      borderColor = Colors.purpleAccent;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))],
        border: Border(left: BorderSide(color: borderColor, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white.withValues(alpha: 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        if (item['avatar'] != null)
                          CircleAvatar(radius: 20, backgroundImage: NetworkImage(item['avatar']))
                        else
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(colors: [Colors.purpleAccent, Colors.pinkAccent]),
                            ),
                            child: const Center(child: Text('Bot', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
                          ),
                        Positioned(
                          bottom: -2,
                          right: -2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: item['type'] == 'PRO' ? primary : const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            child: Text(
                              item['type'],
                              style: TextStyle(color: item['type'] == 'PRO' ? Colors.black : Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['username'], style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('Reported ${item['time']}', style: TextStyle(color: Colors.grey[400], fontSize: 10)),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: borderColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: borderColor.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(item['severity'] == 'medium' ? Icons.visibility_off_outlined : Icons.warning_amber_rounded, color: borderColor, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        item['reason'].toUpperCase(),
                        style: GoogleFonts.spaceGrotesk(color: borderColor, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          if (item['content'] != null)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                item['content'],
                style: GoogleFonts.spaceGrotesk(color: Colors.grey[200], fontSize: 15, height: 1.5),
              ),
            ),
            
          if (item['image'] != null) ...[
            GestureDetector(
              onTap: () => setState(() => _revealedImages.add(item['id'])),
              child: Stack(
                children: [
                  Image.network(
                    item['image'],
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  if (!_revealedImages.contains(item['id']))
                    Positioned.fill(
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.visibility_off_outlined, color: Colors.white, size: 32),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                                  ),
                                  child: const Text('TAP TO REVEAL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Text(item['caption'], style: TextStyle(color: Colors.grey[500], fontSize: 13, fontStyle: FontStyle.italic)),
            ),
          ],
          
          // Actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('KEEP'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primary,
                      side: BorderSide(color: primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('DELETE'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: danger,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 8,
                      shadowColor: danger.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(Color primary, Color background) {
    return Container(
      height: 84,
      decoration: BoxDecoration(
        color: background,
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.dashboard_outlined, 'DASH', false, primary),
          _buildNavItem(Icons.people_outline, 'USERS', false, primary),
          _buildFabNavItem(Icons.gavel, primary),
          _buildNavItem(Icons.forum_outlined, 'FORUM', false, primary),
          _buildNavItem(Icons.settings_outlined, 'SETTINGS', false, primary),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, Color primary) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isActive ? primary : Colors.grey[500], size: 24),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: isActive ? primary : Colors.grey[500], fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
      ],
    );
  }

  Widget _buildFabNavItem(IconData icon, Color primary) {
    return Transform.translate(
      offset: const Offset(0, -10),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: primary,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: primary.withValues(alpha: 0.3), blurRadius: 15, spreadRadius: 2)],
          border: Border.all(color: Colors.black, width: 4),
        ),
        child: const Icon(Icons.gavel, color: Colors.black, size: 28),
      ),
    );
  }

  Widget _buildActionLog(Color primary, Color surface) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => setState(() => _showActionLog = false),
        child: Container(
          color: Colors.black54,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 420,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                    boxShadow: [BoxShadow(color: Colors.black, blurRadius: 40)],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.history, color: primary, size: 24),
                                const SizedBox(width: 12),
                                Text('ACTION LOG', style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
                              ],
                            ),
                            const Text('TODAY', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const Divider(color: Colors.white12),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            _buildLogItem('Deleted', 'post by @toxic_user_1', 'Reason: Hate Speech • 5m ago', Colors.redAccent, primary),
                            _buildLogItem('Kept', 'post by @barber_joe', 'Reason: False Flag • 32m ago', primary, primary),
                            _buildLogItem('Banned', 'user @spambot_3000', 'Reason: Automated Spam • 1h ago', Colors.redAccent, primary),
                            _buildLogItem('Kept', 'post by @nails_by_sarah', 'Reason: Promotion • 2h ago', primary, primary),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogItem(String action, String target, String desc, Color actionColor, Color primary) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: actionColor,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: actionColor.withValues(alpha: 0.5), blurRadius: 6)],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                    children: [
                      TextSpan(text: '$action ', style: TextStyle(color: actionColor, fontWeight: FontWeight.bold)),
                      TextSpan(text: target, style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                Text(desc, style: TextStyle(color: Colors.grey[600], fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
