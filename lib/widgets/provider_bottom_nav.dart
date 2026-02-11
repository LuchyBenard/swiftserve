import 'package:flutter/material.dart';
import '../pages/provider/provider_active_jobs_page.dart';
import '../pages/provider/provider_earnings_page.dart';
import '../pages/provider/provider_availability_page.dart';

class ProviderBottomNav extends StatefulWidget {
  const ProviderBottomNav({super.key});

  @override
  State<ProviderBottomNav> createState() => _ProviderBottomNavState();
}

class _ProviderBottomNavState extends State<ProviderBottomNav> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ProviderActiveJobsPage(),
    const Center(child: Text("Schedule", style: TextStyle(color: Colors.white))),
    const ProviderEarningsPage(),
    const ProviderAvailabilityPage(),
  ];

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF25F46A);
    const pitchBlack = Color(0xFF050505);

    return Scaffold(
      backgroundColor: pitchBlack,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.dashboard_outlined, "Dashboard"),
                _buildNavItem(1, Icons.calendar_today_outlined, "Schedule"),
                const SizedBox(width: 60), // Space for FAB
                _buildNavItem(2, Icons.account_balance_wallet_outlined, "Earnings"),
                _buildNavItem(3, Icons.settings_outlined, "Settings"),
              ],
            ),
            // Floating Action Button
            Positioned(
              top: 0,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: primaryGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primaryGreen.withOpacity(0.4),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.black, size: 28),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    const primaryGreen = Color(0xFF25F46A);
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? primaryGreen : Colors.grey[500],
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? primaryGreen : Colors.grey[500],
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: primaryGreen,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
