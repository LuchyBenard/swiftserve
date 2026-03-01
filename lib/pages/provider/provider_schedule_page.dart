import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProviderSchedulePage extends StatefulWidget {
  const ProviderSchedulePage({super.key});

  @override
  State<ProviderSchedulePage> createState() => _ProviderSchedulePageState();
}

class _ProviderSchedulePageState extends State<ProviderSchedulePage> {
  DateTime _selectedDate = DateTime.now();

  final List<Map<String, dynamic>> _appointments = [
    {
      "time": "09:00 AM",
      "client": "Client: David Miller",
      "service": "Haircut & Beard Trim",
      "status": "Completed",
      "color": const Color(0xFF25F46A),
    },
    {
      "time": "11:30 AM",
      "client": "Client: Mike Ross",
      "service": "Premium Fade",
      "status": "In Progress",
      "color": Colors.amber,
    },
    {
      "time": "02:00 PM",
      "client": "Client: Sarah Jenkins",
      "service": "Style Consultation",
      "status": "Confirmed",
      "color": Colors.blue,
    },
    {
      "time": "04:30 PM",
      "client": "Client: Alex Chen",
      "service": "Beard Grooming",
      "status": "Confirmed",
      "color": Colors.blue,
    },
  ];

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF25F46A);
    const pitchBlack = Color(0xFF050505);

    return Scaffold(
      backgroundColor: pitchBlack,
      body: Stack(
        children: [
          // Background Glow
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryGreen.withOpacity(0.08),
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
                _buildHeader(),
                const SizedBox(height: 24),
                _buildDatePicker(),
                const SizedBox(height: 32),
                Expanded(
                  child: _buildTimeline(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "My Schedule",
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "MANAGE APPOINTMENTS",
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.grey[500],
                  fontSize: 10,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF141E18),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF25F46A).withOpacity(0.1)),
            ),
            child: const Icon(Icons.calendar_month, color: Color(0xFF25F46A), size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 14, // 2 weeks view
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index - 3));
          final isSelected = date.day == _selectedDate.day && date.month == _selectedDate.month;
          final isToday = date.day == DateTime.now().day && date.month == DateTime.now().month;

          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 65,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF25F46A) : const Color(0xFF141E18).withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? const Color(0xFF25F46A) : Colors.white.withOpacity(0.05),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF25F46A).withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        )
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getWeekdayShort(date.weekday),
                    style: GoogleFonts.spaceGrotesk(
                      color: isSelected ? Colors.black : Colors.grey[500],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date.day.toString(),
                    style: GoogleFonts.spaceGrotesk(
                      color: isSelected ? Colors.black : Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isToday && !isSelected)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Color(0xFF25F46A),
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeline() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: _appointments.length,
      itemBuilder: (context, index) {
        final appt = _appointments[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time Side
              SizedBox(
                width: 70,
                child: Text(
                  appt["time"],
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.grey[400],
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Indicator Line
              Column(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: appt["color"],
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                  ),
                  if (index != _appointments.length - 1)
                    Container(
                      width: 1,
                      height: 100,
                      color: Colors.white.withOpacity(0.05),
                    ),
                ],
              ),
              const SizedBox(width: 20),
              // Card
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141E18).withOpacity(0.4),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: (appt["color"] as Color).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              appt["status"].toString().toUpperCase(),
                              style: GoogleFonts.spaceGrotesk(
                                color: appt["color"],
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const Icon(Icons.more_horiz, color: Colors.grey, size: 18),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        appt["client"],
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.content_cut, color: Colors.grey[500], size: 14),
                          const SizedBox(width: 6),
                          Text(
                            appt["service"],
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getWeekdayShort(int day) {
    switch (day) {
      case 1: return "MON";
      case 2: return "TUE";
      case 3: return "WED";
      case 4: return "THU";
      case 5: return "FRI";
      case 6: return "SAT";
      case 7: return "SUN";
      default: return "";
    }
  }
}
