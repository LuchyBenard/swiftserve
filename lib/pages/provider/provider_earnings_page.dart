import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'transaction_history_page.dart';

class ProviderEarningsPage extends StatefulWidget {
  const ProviderEarningsPage({super.key});

  @override
  State<ProviderEarningsPage> createState() => _ProviderEarningsPageState();
}

class _ProviderEarningsPageState extends State<ProviderEarningsPage> {
  String _selectedTimeFrame = 'Week';
  final List<double> _weeklyData = [0.4, 0.65, 0.3, 0.85, 0.95, 0.6, 0.45];
  final List<double> _monthlyData = [0.2, 0.4, 0.35, 0.5, 0.7, 0.6, 0.8, 0.75, 0.9, 0.85, 0.95, 1.0];
  final List<String> _days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  final List<String> _months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

  void _handleWithdraw() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF25F46A)),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Color(0xFF25F46A)),
                const SizedBox(width: 12),
                Text(
                  "Withdrawal Successful!",
                  style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF0F1A12),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF25F46A);
    const pitchBlack = Color(0xFF050505);
    const darkSurface = Color(0xFF0F1A12);

    return Scaffold(
      backgroundColor: pitchBlack,
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
                color: primaryGreen.withOpacity(0.08),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: primaryGreen.withOpacity(0.4)),
                              image: const DecorationImage(
                                image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuAy2lcxBSOYRN65DN1g-Gq6PNmjuY_Nd65gPauKAc1bG_wV4FPk2T1TZtPtH53oZ3abbMgS21GvQnf9R5j9VnccyPquo3A4RenvW1Z_2ooIMRcFkWq5sZCRED5g_2OsUAR9XB2i7PnFyGMIPijH9ZC9SS4HthphB_qy0k8fpOqFe3pWAiy9VbKcKaBJpniHBvdE_pfSivWXMhLIH_lgVWzV4CxS1CGB6Bc2CFcKqKegDyhAfRiDGZ5toOy2iHyJFy4-5UdZsJfdvEl7"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome back,",
                                style: GoogleFonts.spaceGrotesk(color: Colors.grey[400], fontSize: 13),
                              ),
                              Text(
                                "Marcus T. • Professional Barber",
                                style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Stack(
                          children: [
                            const Icon(Icons.notifications_none, color: Colors.grey),
                            Positioned(
                              right: 2,
                              top: 2,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: primaryGreen,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        // Balance Card
                        _buildBalanceCard(),

                        const SizedBox(height: 32),
                        // Analytics Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "$_selectedTimeFrame Analytics",
                              style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: darkSurface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white.withOpacity(0.05)),
                              ),
                              child: Row(
                                children: [
                                  _buildTimeToggle("Week", _selectedTimeFrame == "Week"),
                                  _buildTimeToggle("Month", _selectedTimeFrame == "Month"),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                        // Bar Chart
                        _buildBarChart(),

                        const SizedBox(height: 32),
                        // Transactions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Recent Transactions",
                              style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                               onTap: () {
                                 Navigator.push(
                                   context,
                                   MaterialPageRoute(builder: (context) => const TransactionHistoryPage()),
                                 );
                               },
                               child: Text(
                                 "See All",
                                 style: GoogleFonts.spaceGrotesk(color: primaryGreen, fontSize: 14, fontWeight: FontWeight.w500),
                               ),
                             ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildTransactionItem("Haircut & Beard Trim", "Client: David Miller", "2 hours ago", "+\$45.00", Icons.content_cut),
                        _buildTransactionItem("Style Consultation", "Client: Sarah Jenkins", "Yesterday", "+\$25.00", Icons.brush),
                        _buildTransactionItem("Premium Fade", "Client: Mike Ross", "Yesterday", "+\$35.00", Icons.content_cut),
                        _buildTransactionItem("Head Shave", "Client: Alex Chen", "Oct 24", "+\$30.00", Icons.face),
                        
                        const SizedBox(height: 100),
                      ],
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

  Widget _buildBalanceCard() {
    const primaryGreen = Color(0xFF25F46A);
    const darkSurface = Color(0xFF0F1A12);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF141E18).withOpacity(0.4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: primaryGreen.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "TOTAL BALANCE",
            style: GoogleFonts.spaceGrotesk(color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1.2),
          ),
          const SizedBox(height: 8),
          const Text(
            "\$2,845.50",
            style: TextStyle(
              color: primaryGreen,
              fontSize: 36,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(color: primaryGreen, blurRadius: 10)],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _handleWithdraw,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Withdraw",
                          style: GoogleFonts.spaceGrotesk(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_outward, color: Colors.black, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: darkSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: primaryGreen.withOpacity(0.1)),
                ),
                child: const Icon(Icons.more_horiz, color: primaryGreen),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeToggle(String label, bool isActive) {
    return GestureDetector(
      onTap: () => setState(() => _selectedTimeFrame = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey[500],
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

   Widget _buildBarChart() {
    const primaryGreen = Color(0xFF25F46A);
    final isWeekly = _selectedTimeFrame == "Week";
    final data = isWeekly ? _weeklyData : _monthlyData;
    final labels = isWeekly ? _days : _months;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: 180,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(data.length, (index) {
            bool isHighlight = isWeekly ? index == 4 : (index == 9 || index == 11);
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isHighlight)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isWeekly ? "\$450" : "\$${(data[index] * 5000).toInt()}",
                        style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  Container(
                    width: 32,
                    height: 120 * data[index],
                    decoration: BoxDecoration(
                      color: isHighlight ? primaryGreen : primaryGreen.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: isHighlight ? [BoxShadow(color: primaryGreen.withOpacity(0.4), blurRadius: 10)] : [],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    labels[index],
                    style: GoogleFonts.spaceGrotesk(
                      color: isHighlight ? primaryGreen : Colors.grey[500],
                      fontSize: 10,
                      fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(String title, String subtitle, String time, String amount, IconData icon) {
    const primaryGreen = Color(0xFF25F46A);
    const darkSurface = Color(0xFF0F1A12);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141E18).withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryGreen.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: darkSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
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
                Text(
                  "$subtitle • $time",
                  style: TextStyle(color: Colors.grey[500], fontSize: 11),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: GoogleFonts.spaceGrotesk(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Text(
                "COMPLETED",
                style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
