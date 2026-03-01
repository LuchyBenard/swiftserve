import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../welcome/welcome_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Animation Controllers
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Floating Animation (for Slide 1)
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    
    _floatAnimation = Tween<double>(begin: 0, end: -15).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Pulse Animation (for Slide 2 & 3)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _floatController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
      );
    }
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    const neonGreen = Color(0xFF25F46A);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Global Background Glow
          Positioned(
            top: MediaQuery.of(context).size.height / 3,
            left: MediaQuery.of(context).size.width / 2 - 150,
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

          // Page View
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            children: [
              _buildSlide1(neonGreen),
              _buildSlide2(neonGreen),
              _buildSlide3(neonGreen),
            ],
          ),

          // Skip Button (Moved after PageView to be clickable)
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: _completeOnboarding,
              child: Text(
                'Skip',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Bottom Controls
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Column(
              children: [
                // Page Indicator
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    activeDotColor: neonGreen,
                    dotColor: Colors.grey.shade800,
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 8,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Next/Get Started Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: neonGreen,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                      shadowColor: neonGreen.withOpacity(0.5),
                    ).copyWith(
                      shadowColor: WidgetStateProperty.all(neonGreen.withOpacity(0.4)),
                      elevation: WidgetStateProperty.all(10), 
                    ),
                    child: Text(
                      _currentPage == 2 ? 'Get Started' : 'Next',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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

  // Slide 1: Discover Services
  Widget _buildSlide1(Color neonGreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Visuals
          SizedBox(
            height: 400,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Central Card/Phone
                Container(
                  width: 200,
                  height: 320,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: neonGreen.withOpacity(0.5), width: 2),
                    boxShadow: [
                      BoxShadow(color: neonGreen.withOpacity(0.2), blurRadius: 20),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       _buildMockRow(neonGreen, Icons.content_cut),
                       _buildMockRow(neonGreen, Icons.build),
                       _buildMockRow(neonGreen, Icons.smartphone),
                    ],
                  ),
                ),
                
                // Floating Icons
                _buildFloatingIcon(Icons.build, neonGreen, -70, -40, 0),
                _buildFloatingIcon(Icons.content_cut, neonGreen, 70, -100, 500), // Delayed
                _buildFloatingIcon(Icons.smartphone, neonGreen, 80, 100, 1000), 
                _buildFloatingIcon(Icons.location_on, neonGreen, -90, 80, 1500),
              ],
            ),
          ),
          
          const SizedBox(height: 40),
          
          Text(
            'Find Experts\nNear You',
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Connect with top-rated technicians,\nbarbers, and stylists in seconds.',
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 16,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 100), // Space for bottom controls
        ],
      ),
    );
  }

  Widget _buildMockRow(Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(width: 60, height: 6, decoration: BoxDecoration(color: color.withOpacity(0.4), borderRadius: BorderRadius.circular(3))),
              const SizedBox(height: 4),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFloatingIcon(IconData icon, Color color, double x, double y, int delay) {
    // Basic Float
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        // Add some phase offset based on x/y roughly or just use simpler flow
        final val = _floatAnimation.value; 
        return Transform.translate(
          offset: Offset(x, y + val), // Simple bounce
          // For more complex delay, we might need multiple controllers or just sine wave math. 
          // Keeping it simple with one controller for now, maybe add slight variation manually?
          // Actually, let's just let them sync for simplicity or use a single listener.
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color),
              boxShadow: [
                 BoxShadow(color: color.withOpacity(0.3), blurRadius: 10),
              ],
            ),
            child: Icon(icon, color: color, size: 24),
          ),
        );
      },
    );
  }

  // Slide 2: Easy Booking
  Widget _buildSlide2(Color neonGreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           ScaleTransition(
             scale: _pulseAnimation,
             child: Container(
               width: 180,
               height: 180,
               decoration: BoxDecoration(
                 shape: BoxShape.circle,
                 boxShadow: [
                   BoxShadow(
                     color: neonGreen.withOpacity(0.2),
                     blurRadius: 40,
                     spreadRadius: 10,
                   )
                 ]
               ),
               child: Icon(
                 Icons.event_available,
                 size: 100,
                 color: neonGreen,
               ),
             ),
           ),
           
           const SizedBox(height: 60),

           Text(
            'Easy Booking &\nTracking',
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Schedule appointments and track\nyour service provider in real-time.',
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 16,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  // Slide 3: Secure & Reliable
  Widget _buildSlide3(Color neonGreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
            SizedBox(
              height: 250,
              width: 250,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Shield
                  Icon(
                    Icons.verified_user_outlined,
                    size: 180,
                    color: neonGreen,
                    shadows: [
                       BoxShadow(
                         color: neonGreen.withOpacity(0.5),
                         blurRadius: 30,
                       )
                    ],
                  ),
                  // Wallet Card - Rotated
                  Positioned(
                    bottom: 20,
                    right: 0,
                    child: Transform.rotate(
                      angle: -0.2,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white10),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.8), blurRadius: 20, offset: const Offset(0, 10)),
                          ],
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 60),

            Text(
            'Secure & Reliable',
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Safe transactions and verified\nprofessionals for your peace of mind.',
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 16,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 100),
         ]
      ),
    );
  }
}
