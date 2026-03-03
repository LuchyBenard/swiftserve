import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF25F46A);
    const pitchBlack = Color(0xFF000000);
    const backgroundDark = Color(0xFF050505);
    const darkSurface = Color(0xFF0F1A12);
    const darkAccent = Color(0xFF1A2E20);

    return Scaffold(
      backgroundColor: backgroundDark,
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -150,
            right: -50,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryGreen.withValues(alpha: 0.05),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryGreen.withValues(alpha: 0.05),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(primaryGreen, darkSurface, darkAccent),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        _buildStatsScroll(primaryGreen),
                        const SizedBox(height: 32),
                        _buildRevenueOverview(primaryGreen, darkSurface),
                        const SizedBox(height: 32),
                        _buildLiveJobActivity(primaryGreen, darkSurface),
                        const SizedBox(height: 100), // Bottom Nav Spacer
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Navigation
          _buildBottomNav(primaryGreen, pitchBlack),
        ],
      ),
    );
  }

  Widget _buildHeader(Color primary, Color surface, Color accent) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ADMIN PORTAL",
                style: GoogleFonts.spaceGrotesk(
                  color: primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Dashboard",
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: const Icon(Icons.search, color: Colors.grey, size: 20),
              ),
              const SizedBox(width: 12),
              Stack(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primary.withValues(alpha: 0.2)),
                      image: const DecorationImage(
                        image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuAy2lcxBSOYRN65DN1g-Gq6PNmjuY_Nd65gPauKAc1bG_wV4FPk2T1TZtPtH53oZ3abbMgS21GvQnf9R5j9VnccyPquo3A4RenvW1Z_2ooIMRcFkWq5sZCRED5g_2OsUAR9XB2i7PnFyGMIPijH9ZC9SS4HthphB_qy0k8fpOqFe3pWAiy9VbKcKaBJpniHBvdE_pfSivWXMhLIH_lgVWzV4CxS1CGB6Bc2CFcKqKegDyhAfRiDGZ5toOy2iHyJFy4-5UdZsJfdvEl7"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsScroll(Color primary) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildRevenueCard(primary),
          const SizedBox(width: 16),
          _buildStatCard(
            label: "Active Users",
            value: "8,420",
            subtext: "Currently online: ",
            subvalue: "1,204",
            icon: Icons.group_outlined,
            iconColor: Colors.blueAccent,
            primary: primary,
            width: 180,
          ),
          const SizedBox(width: 16),
          _buildStatCard(
            label: "Pending Verif.",
            value: "42",
            subtext: "Needs Review",
            subvalue: "",
            icon: Icons.verified_user_outlined,
            iconColor: Colors.orangeAccent,
            primary: primary,
            width: 180,
            hasPulse: true,
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueCard(Color primary) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF141E18).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primary.withValues(alpha: 0.1)),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.monetization_on, color: primary, size: 20),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: primary.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.trending_up, color: primary, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          "+12.5%",
                          style: GoogleFonts.spaceGrotesk(
                            color: primary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Total Revenue",
                style: GoogleFonts.spaceGrotesk(color: Colors.grey[400], fontSize: 13),
              ),
              const SizedBox(height: 4),
              const Text(
                "\$124,592",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
          Positioned(
            bottom: -10,
            left: -20,
            right: -20,
            child: SizedBox(
              height: 40,
              child: CustomPaint(
                painter: SparklinePainter(primary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required String subtext,
    required String subvalue,
    required IconData icon,
    required Color iconColor,
    required Color primary,
    required double width,
    bool hasPulse = false,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF141E18).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              if (hasPulse)
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: iconColor,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: iconColor, blurRadius: 4, spreadRadius: 1)],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(color: Colors.grey[400], fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: subtext,
                  style: GoogleFonts.spaceGrotesk(color: Colors.grey[600], fontSize: 10),
                ),
                TextSpan(
                  text: subvalue,
                  style: GoogleFonts.spaceGrotesk(color: primary, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueOverview(Color primary, Color surface) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Revenue Overview",
              style: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Row(
                children: [
                  Text(
                    "This Week",
                    style: GoogleFonts.spaceGrotesk(color: Colors.grey[400], fontSize: 11),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 16),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 240,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF141E18).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: primary.withValues(alpha: 0.1)),
          ),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    // Grid Lines
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(5, (_) => Container(height: 1, color: Colors.white10)),
                    ),
                    // Main Chart
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: CustomPaint(
                        size: Size.infinite,
                        painter: MainChartPainter(primary),
                      ),
                    ),
                    // Tooltip mockup
                    Positioned(
                      left: 140,
                      top: 40,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A2E20),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: primary, width: 1),
                        ),
                        child: Text(
                          "\$4.2k",
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                    .map((d) => Text(d, style: GoogleFonts.spaceGrotesk(color: Colors.grey[600], fontSize: 10)))
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLiveJobActivity(Color primary, Color surface) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Live Job Activity",
              style: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: const Icon(Icons.filter_list, color: Colors.grey, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildActivityItem(
          title: "Premium Grooming",
          subtitle: "Barber: Marcus T. • Loc: Downtown",
          status: "In Progress",
          time: "12m remaining",
          icon: Icons.content_cut,
          primary: primary,
          isActive: true,
        ),
        _buildActivityItem(
          title: "Pipe Leak Repair",
          subtitle: "Tech: Sarah J. • Loc: Westside",
          status: "Escalated",
          time: "Report #4421",
          icon: Icons.plumbing,
          primary: Colors.redAccent,
          isUrgent: true,
        ),
        _buildActivityItem(
          title: "Wiring Inspection",
          subtitle: "Tech: Alex C. • Loc: Suburbs",
          status: "Completed",
          time: "2 mins ago",
          icon: Icons.electrical_services,
          primary: Colors.grey,
        ),
        _buildActivityItem(
          title: "Full Body Massage",
          subtitle: "Therapist: Lena K. • Loc: Uptown",
          status: "In Progress",
          time: "45m remaining",
          icon: Icons.spa,
          primary: primary,
          isActive: true,
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String subtitle,
    required String status,
    required String time,
    required IconData icon,
    required Color primary,
    bool isActive = false,
    bool isUrgent = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141E18).withValues(alpha: isUrgent ? 0.3 : 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isUrgent ? Colors.redAccent.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Icon(icon, color: Colors.grey, size: 20),
              ),
              if (isActive)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 10),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: primary.withValues(alpha: 0.2)),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: GoogleFonts.spaceGrotesk(
                    color: primary,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(color: Colors.grey[600], fontSize: 9),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(Color primary, Color pitchBlack) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: pitchBlack.withValues(alpha: 0.9),
          border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(Icons.dashboard, "Overview", 0, primary),
                  _navItem(Icons.people_outline, "Users", 1, primary),
                  _navItem(Icons.engineering_outlined, "Providers", 2, primary),
                  _navItem(Icons.category_outlined, "Cats", 3, primary),
                  _navItem(Icons.gavel_outlined, "Mod", 4, primary),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index, Color primary) {
    bool isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isActive)
              Container(
                width: 24,
                height: 3,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(3)),
                  boxShadow: [BoxShadow(color: primary, blurRadius: 10)],
                ),
              )
            else
              const SizedBox(height: 11),
            Icon(
              icon,
              color: isActive ? primary : Colors.grey[600],
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                color: isActive ? primary : Colors.grey[600],
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SparklinePainter extends CustomPainter {
  final Color color;
  SparklinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.1, size.height * 0.8, size.width * 0.2, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.3, size.height * 0.6, size.width * 0.4, size.height * 0.65);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.65, size.width * 0.6, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.7, size.height * 0.5, size.width * 0.8, size.height * 0.55);
    path.quadraticBezierTo(size.width * 0.9, size.height * 0.55, size.width, size.height * 0.2);

    canvas.drawPath(path, paint);

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class MainChartPainter extends CustomPainter {
  final Color color;
  MainChartPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.cubicTo(
      size.width * 0.2, size.height * 0.7, 
      size.width * 0.2, size.height * 0.9, 
      size.width * 0.33, size.height * 0.5
    );
    path.cubicTo(
      size.width * 0.46, size.height * 0.2, 
      size.width * 0.46, size.height * 0.6, 
      size.width * 0.6, size.height * 0.4
    );
    path.cubicTo(
      size.width * 0.8, size.height * 0.6, 
      size.width * 0.8, size.height * 0.1, 
      size.width, size.height * 0.1
    );

    // Filter glow effect (simplified using stroke)
    final shadowPaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    
    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    // Highlight points
    final pointPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(Offset(size.width * 0.33, size.height * 0.5), 5, pointPaint);
    canvas.drawCircle(Offset(size.width * 0.33, size.height * 0.5), 5, borderPaint);

    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.4), 5, pointPaint);
    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.4), 5, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
