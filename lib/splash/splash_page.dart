import 'dart:async';
import 'package:flutter/material.dart';
// Determine if available or use fallback
import '../widgets/auth_gate.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  late AnimationController _spinController;

  @override
  void initState() {
    super.initState();

    // Pulse Animation for Background Glow
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Spin Animation for Loader
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Navigation Timer
    Timer(const Duration(seconds: 7), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthGate()),
        );
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine font family, fallback to standard if GoogleFonts not available
    // Assuming we can't easily check pubspec in this turn, we'll try to use GoogleFonts
    // If it fails compile, I can fix it. But safer to wrap or use standard for now if unsure.
    // For now, I'll use a TextStyle that resembles 'Space Grotesk' via standard font or GoogleFonts if I knew it was there.
    // I will use standard TextStyle with some tweaks to keep it safe, or assume google_fonts is added as it is common.
    // ACTUALLY, the prompt had <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk...
    // I will try to use GoogleFonts.spaceGrotesk if possible, strictly fallback to 'Sans Serif'.
    
    const neonGreen = Color(0xFF25F46A);
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Glow
          Positioned(
            top: MediaQuery.of(context).size.height / 3 - 300,
            left: MediaQuery.of(context).size.width / 2 - 300,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 600,
                    height: 600,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: neonGreen.withOpacity(0.05),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Section
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Distorted Shadow 'S' (Approximation)
                      Transform(
                        transform: Matrix4.skewX(-0.1)..scale(1.0, 1.1),
                        child: Text(
                          'S',
                          style: TextStyle(
                            fontSize: 140,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.05),
                            height: 1,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      // Main 'S'
                      Text(
                        'S',
                        style: TextStyle(
                            fontSize: 120,
                            fontWeight: FontWeight.bold,
                            height: 1,
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                        ),
                      ),
                      // Lightning Bolt
                      Positioned(
                         child: Icon(
                           Icons.bolt,
                           size: 100,
                           color: neonGreen,
                           shadows: [
                             BoxShadow(
                               color: neonGreen.withOpacity(0.8),
                               blurRadius: 25,
                               spreadRadius: 5,
                             )
                           ],
                         ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // SwiftServe Title
                Text(
                  'SwiftServe',
                  style: TextStyle( // Fallback if GoogleFonts not present
                    fontFamily: 'Space Grotesk', // Try this name if added cleanly
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom Loader & Footer
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Custom Loader
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Stack(
                    children: [
                      // Static Ring
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                      ),
                      // Spinning Segment
                      AnimatedBuilder(
                        animation: _spinController,
                        builder: (context, child) {
                          return RotationTransition(
                            turns: _spinController,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.transparent, // colored part handled by gradient or partial border? 
                                  // Simplified:
                                ),
                              ),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(neonGreen),
                                strokeWidth: 2,
                                backgroundColor: Colors.transparent, // partial styling
                              ),
                              // Or better custom painter for partial ring
                            ),
                          );
                        },
                      ),
                      // Center Dot
                      Center(
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: neonGreen,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: neonGreen,
                                blurRadius: 8,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Footer
                Text(
                  'POWERED BY SWIFTSERVE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
