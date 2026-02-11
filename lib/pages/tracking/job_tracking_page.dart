import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../chat_page.dart';
import '../rating/rate_provider_page.dart';
import '../../models/conversation.dart';

class JobTrackingPage extends StatefulWidget {
  final String providerName;
  final String serviceType;
  final String providerImageUrl;

  const JobTrackingPage({
    super.key,
    this.providerName = 'Marcus Vane',
    this.serviceType = 'Master Barber',
    this.providerImageUrl = 'https://lh3.googleusercontent.com/aida-public/AB6AXuC2rC0jTUAzlbWZb9L6KQ87L1pOOJM3JGf2QQ5U9yc3GxyHKieh_lzQ2QwbRBLHFq86YShsjQqioBqk1WO0mn0FsfGMzJtfc7mTd5BIiid_rfQ6Vm2lqFkSYCHvfNjP_sMRBLptPVdg2tSRJ5hLdf1zUzXLb4-2OaF5Q_KsGq58Dk73VnUqWPFbBTumHh8J7JevvFKPnrtDuP0m4NaEk-9ITeRB1wrx39AbwC-8vhcy0KoLxqdbU9pGWneDYeXOkcjBaRc5AYYmRmKa',
  });

  @override
  State<JobTrackingPage> createState() => _JobTrackingPageState();
}

class _JobTrackingPageState extends State<JobTrackingPage> {
  void _makeCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '+2348001234567', // Mock phone number
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch dialer')),
      );
    }
  }

  void _goToChat() {
    // Create a mock conversation for the tracker
    final conversation = Conversation(
      id: 'tracking_chat_${widget.providerName.replaceAll(' ', '_')}',
      providerName: widget.providerName,
      lastMessage: 'I am on my way!',
      time: 'Now',
      avatarUrl: widget.providerImageUrl,
      isOnline: true,
      isUnread: false,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(conversation: conversation),
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
          // Background Glows
          Positioned(
            top: 300,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: neonGreen.withOpacity(0.05),
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
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        _buildMapSection(neonGreen),
                        _buildProviderCard(neonGreen),
                        _buildServiceStatus(neonGreen),
                        const SizedBox(height: 120), // Padding for bottom nav
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Custom Bottom Navigation (matching app style)
          _buildFloatingBottomNav(neonGreen),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
            ),
          ),
          Column(
            children: [
              Text(
                'LIVE STATUS',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.grey[500],
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              Text(
                '${widget.providerName} En-route',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: const Icon(Icons.more_vert, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection(Color neonGreen) {
    return Container(
      height: 320,
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Stack(
        children: [
          // Simplified Map Background Grid/Lines
          Positioned.fill(
            child: CustomPaint(
              painter: MapPainter(),
            ),
          ),

          // Provider Marker (Moving)
          Positioned(
            top: 60,
            right: 80,
            child: _buildMarker(
              icon: Icons.directions_car,
              label: 'PROVIDER',
              color: neonGreen,
              isGlowing: true,
            ),
          ),

          // User Marker (Stationary)
          Positioned(
            bottom: 80,
            left: 90,
            child: Column(
              children: [
                 Container(
                    width: 44,
                    height: 44,
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const CircleAvatar(
                      backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuCqaZ7wk8boFIodQC_72x7gFRiF-KA6YLJuS5oG787ow5E6cLDav6l_BvN9b8MFowza2zKonigLZuY4910ShpjHQLW9A7Fj_7k6AMzI0JNMBa1EOrExgnZr_W-t9OZWd02hW3qIm5zf3KHs_Opa9s_8_0MeRGhiLbBxE2owIqQY84oOJOEsTnjK3hkyVvq9ZcrEhEgDCgilg-b8o7f2kH-IhMntmDQcIhOIU54NJFLtCj-XVoZVmtQoEdxEm2dI5zYAJ18MQ_JQ2d6b'),
                    ),
                 ),
                 const SizedBox(height: 8),
                 Container(
                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                   decoration: BoxDecoration(
                     color: Colors.black.withOpacity(0.6),
                     borderRadius: BorderRadius.circular(4),
                     border: Border.all(color: Colors.white10),
                   ),
                   child: Text('YOU', style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                 )
              ],
            ),
          ),

          // Dashed Path line
          Positioned.fill(
             child: CustomPaint(
               painter: DashPathPainter(color: neonGreen),
             ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarker({required IconData icon, required String label, required Color color, bool isGlowing = false}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: isGlowing ? [
              BoxShadow(color: color.withOpacity(0.5), blurRadius: 15, spreadRadius: 2),
            ] : null,
          ),
          child: Icon(icon, color: Colors.black, size: 20),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(label, style: GoogleFonts.spaceGrotesk(color: Colors.black, fontSize: 8, fontWeight: FontWeight.bold)),
        )
      ],
    );
  }

  Widget _buildProviderCard(Color neonGreen) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: neonGreen.withOpacity(0.3), width: 2),
                image: DecorationImage(
                  image: NetworkImage(widget.providerImageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.providerName,
                    style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: neonGreen, size: 14),
                      const SizedBox(width: 4),
                      Text('4.9 • ${widget.serviceType}', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: _makeCall,
                  child: _buildActionIcon(Icons.call, Colors.white.withOpacity(0.1)),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _goToChat,
                  child: _buildActionIcon(Icons.chat_bubble, neonGreen.withOpacity(0.2), iconColor: neonGreen),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, Color bg, {Color iconColor = Colors.white}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }

  Widget _buildServiceStatus(Color neonGreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text('Service Status', style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                 Text('EST. 8 MINS', style: GoogleFonts.spaceGrotesk(color: neonGreen.withOpacity(0.6), fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 1)),
               ],
             ),
             const SizedBox(height: 32),
             _buildStatusItem('Job Accepted', 'Provider confirmed your booking', true, true, neonGreen),
             _buildStatusItem('Provider Arriving', '${widget.providerName.split(' ')[0]} is currently 1.2 miles away', true, false, neonGreen, isActive: true),
             _buildStatusItem('In Progress', 'Service starts upon arrival', false, false, neonGreen),
             _buildStatusItem('Completed', 'Review your service experience', false, false, neonGreen, isLast: true),
             const SizedBox(height: 16),
             GestureDetector(
               onTap: () {
                 Navigator.push(
                   context,
                   MaterialPageRoute(
                     builder: (context) => RateProviderPage(
                       providerName: widget.providerName,
                       providerRole: widget.serviceType,
                       providerImageUrl: widget.providerImageUrl,
                     ),
                   ),
                 );
               },
               child: Container(
                 width: double.infinity,
                 padding: const EdgeInsets.symmetric(vertical: 16),
                 decoration: BoxDecoration(
                   color: neonGreen,
                   borderRadius: BorderRadius.circular(16),
                   boxShadow: [
                     BoxShadow(color: neonGreen.withOpacity(0.3), blurRadius: 10),
                   ],
                 ),
                 child: Center(
                   child: Text(
                     'Rate Provider',
                     style: GoogleFonts.spaceGrotesk(
                       color: Colors.black,
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                 ),
               ),
             ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String title, String desc, bool isDone, bool hasNextLine, Color neonGreen, {bool isActive = false, bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: isDone ? neonGreen : Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: isDone ? [BoxShadow(color: neonGreen.withOpacity(0.5), blurRadius: 10)] : null,
              ),
            ),
            if (!isLast)
              Container(
                 width: 2,
                 height: 40,
                 color: isDone ? neonGreen : Colors.white.withOpacity(0.1),
              ),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.spaceGrotesk(
                  color: isActive ? neonGreen : (isDone ? Colors.white : Colors.grey[600]),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: TextStyle(
                  color: isDone ? Colors.grey[400] : Colors.grey[700],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildFloatingBottomNav(Color neonGreen) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A).withOpacity(0.9),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(Icons.home, 'Home', false, Colors.grey),
                  _buildNavItem(Icons.history, 'History', true, neonGreen),
                  const SizedBox(width: 70), // Space for bolt button
                  _buildNavItem(Icons.chat_bubble_outline, 'Chat', false, Colors.grey),
                  _buildNavItem(Icons.person_outline, 'Profile', false, Colors.grey),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 2),
        Text(label, style: GoogleFonts.spaceGrotesk(color: color, fontSize: 10, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 2;
    
    // Draw some random map lines
    canvas.drawLine(const Offset(40, 100), const Offset(200, 40), paint);
    canvas.drawLine(const Offset(0, 200), const Offset(300, 220), paint);
    canvas.drawLine(const Offset(250, 0), const Offset(280, 320), paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class DashPathPainter extends CustomPainter {
  final Color color;
  DashPathPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.5)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.8, size.height * 0.2)
      ..quadraticBezierTo(
        size.width * 0.5, 
        size.height * 0.4, 
        size.width * 0.3, 
        size.height * 0.7,
      );

    // Draw dashed path
    double dashWidth = 8, dashSpace = 4, distance = 0;
    for (PathMetric measurePath in path.computeMetrics()) {
      while (distance < measurePath.length) {
        canvas.drawPath(
          measurePath.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
