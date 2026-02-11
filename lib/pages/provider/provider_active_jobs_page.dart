import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProviderActiveJobsPage extends StatefulWidget {
  const ProviderActiveJobsPage({super.key});

  @override
  State<ProviderActiveJobsPage> createState() => _ProviderActiveJobsPageState();
}

class _ProviderActiveJobsPageState extends State<ProviderActiveJobsPage> {
  bool _showActive = true;

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF25F46A);
    const pitchBlack = Color(0xFF050505);
    const darkSurface = Color(0xFF0F1A12);
    const cardDark = Color(0xFF161B17);

    return Scaffold(
      backgroundColor: pitchBlack,
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryGreen.withOpacity(0.05),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "My Assignments",
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Stack(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: darkSurface,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withOpacity(0.05)),
                            ),
                            child: const Icon(Icons.notifications_none, color: Colors.grey, size: 22),
                          ),
                          Positioned(
                            right: 12,
                            top: 10,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: primaryGreen,
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(color: primaryGreen.withOpacity(0.5), blurRadius: 4)],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Custom Toggle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: darkSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Row(
                      children: [
                        Expanded(child: _buildToggleItem("Active Jobs", _showActive, () => setState(() => _showActive = true))),
                        Expanded(child: _buildToggleItem("Completed", !_showActive, () => setState(() => _showActive = false))),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),
                
                // Job List
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      _buildJobCard(
                        title: "AC Repair",
                        ticketId: "#8392",
                        address: "42 Westbury Lane, Downtown",
                        distance: "2.4 km away",
                        icon: Icons.ac_unit,
                        isUrgent: true,
                        isPrimaryNavigate: true,
                      ),
                      _buildJobCard(
                        title: "Haircut & Beard",
                        ticketId: "#8401",
                        address: "105 Park Avenue, Suite 4B",
                        distance: "5.1 km away",
                        icon: Icons.content_cut,
                        timeTag: "14:00 PM",
                      ),
                      _buildJobCard(
                        title: "Pipe Leakage",
                        ticketId: "#8415",
                        address: "88 Green Street, Suburbs",
                        distance: "12.8 km away",
                        icon: Icons.plumbing,
                        timeTag: "16:30 PM",
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.spaceGrotesk(
            color: isActive ? Colors.white : Colors.grey[500],
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildJobCard({
    required String title,
    required String ticketId,
    required String address,
    required String distance,
    required IconData icon,
    bool isUrgent = false,
    bool isPrimaryNavigate = false,
    String? timeTag,
  }) {
    const primaryGreen = Color(0xFF25F46A);
    const cardDark = Color(0xFF161B17);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isUrgent ? const Color(0xFF102216).withOpacity(0.6) : cardDark,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isUrgent ? primaryGreen.withOpacity(0.1) : Colors.white.withOpacity(0.05)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            if (isUrgent)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: primaryGreen,
                    boxShadow: [BoxShadow(color: primaryGreen, blurRadius: 10)],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isUrgent ? primaryGreen.withOpacity(0.1) : Colors.white.withOpacity(0.05),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(icon, color: isUrgent ? primaryGreen : Colors.grey[400], size: 20),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title, style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
                              Text("Ticket $ticketId", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      if (isUrgent)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: primaryGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: primaryGreen.withOpacity(0.2)),
                          ),
                          child: const Text("URGENT", style: TextStyle(color: primaryGreen, fontSize: 10, fontWeight: FontWeight.bold)),
                        )
                      else if (timeTag != null)
                        Text(timeTag, style: TextStyle(color: Colors.grey[500], fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          address,
                          style: TextStyle(color: Colors.grey[300], fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.straighten, color: Colors.grey, size: 14),
                            const SizedBox(width: 6),
                            Text(distance, style: TextStyle(color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isPrimaryNavigate ? primaryGreen : Colors.transparent,
                          foregroundColor: isPrimaryNavigate ? Colors.black : primaryGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: isPrimaryNavigate ? BorderSide.none : const BorderSide(color: primaryGreen, width: 1.5),
                          ),
                          elevation: isPrimaryNavigate ? 10 : 0,
                          shadowColor: primaryGreen.withOpacity(0.5),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.navigation, size: 16),
                            const SizedBox(width: 6),
                            Text("Navigate", style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
