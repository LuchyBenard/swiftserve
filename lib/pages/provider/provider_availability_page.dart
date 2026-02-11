import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProviderAvailabilityPage extends StatefulWidget {
  const ProviderAvailabilityPage({super.key});

  @override
  State<ProviderAvailabilityPage> createState() => _ProviderAvailabilityPageState();
}

class _ProviderAvailabilityPageState extends State<ProviderAvailabilityPage> {
  double _radius = 25.0;
  final Map<String, bool> _schedule = {
    "Monday": true,
    "Tuesday": true,
    "Wednesday": true,
    "Thursday": true,
    "Friday": true,
    "Saturday": false,
    "Sunday": false,
  };

  final Map<String, String> _hours = {
    "Monday": "09:00 AM - 05:00 PM",
    "Tuesday": "09:00 AM - 05:00 PM",
    "Wednesday": "09:00 AM - 05:00 PM",
    "Thursday": "09:00 AM - 05:00 PM",
    "Friday": "09:00 AM - 04:00 PM",
    "Saturday": "Unavailable",
    "Sunday": "Unavailable",
  };

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
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
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
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        "Availability",
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 48), // Spacer
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        // Radius Section
                        _buildRadiusCard(),

                        const SizedBox(height: 40),
                        // Schedule Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Weekly Schedule",
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Apply to all",
                              style: TextStyle(color: primaryGreen, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        // Schedule List
                        ..._schedule.keys.map((day) => _buildScheduleItem(day)),

                        const SizedBox(height: 40),
                        // Save Button
                        Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: primaryGreen.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryGreen,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.save, color: Colors.black, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  "Save Preferences",
                                  style: GoogleFonts.spaceGrotesk(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
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

  Widget _buildRadiusCard() {
    const primaryGreen = Color(0xFF25F46A);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF142216).withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primaryGreen.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.radar, color: primaryGreen, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Service Radius",
                    style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
              Text(
                "${_radius.toInt()} km",
                style: const TextStyle(color: primaryGreen, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              activeTrackColor: primaryGreen.withOpacity(0.5),
              inactiveTrackColor: Colors.white.withOpacity(0.1),
              thumbColor: primaryGreen,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayColor: primaryGreen.withOpacity(0.2),
            ),
            child: Slider(
              value: _radius,
              min: 5,
              max: 50,
              onChanged: (val) => setState(() => _radius = val),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("5 km", style: TextStyle(color: Colors.grey[600], fontSize: 11)),
              Text("50 km", style: TextStyle(color: Colors.grey[600], fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(String day) {
    const primaryGreen = Color(0xFF25F46A);
    bool isActive = _schedule[day]!;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isActive ? Colors.transparent : Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? primaryGreen.withOpacity(0.1) : Colors.white.withOpacity(0.05)),
        image: isActive ? null : null, // Transparent build panels in HTML
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                day,
                style: GoogleFonts.spaceGrotesk(
                  color: isActive ? Colors.white : Colors.grey[500],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _hours[day]!,
                style: TextStyle(
                  color: isActive ? primaryGreen.withOpacity(0.8) : Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: isActive,
              onChanged: (val) => setState(() => _schedule[day] = val),
              activeColor: primaryGreen,
              activeTrackColor: primaryGreen.withOpacity(0.3),
              inactiveThumbColor: Colors.grey[600],
              inactiveTrackColor: Colors.white.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}
