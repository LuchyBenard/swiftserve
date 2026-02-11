import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'step1_details.dart';
import 'step2_schedule.dart';
import 'step3_review.dart';
import '../../models/provider.dart';

class CreateRequestFlow extends StatefulWidget {
  final String? initialService;
  final Provider? provider;

  const CreateRequestFlow({super.key, this.initialService, this.provider});

  @override
  State<CreateRequestFlow> createState() => _CreateRequestFlowState();
}

class _CreateRequestFlowState extends State<CreateRequestFlow> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  // Shared Data across steps
  late final Map<String, dynamic> _requestData;

  @override
  void initState() {
    super.initState();
    _requestData = {
      'description': widget.provider != null 
          ? 'I need help with ${widget.provider!.role} services.' 
          : (widget.initialService != null 
              ? 'I need help with ${widget.initialService} services.' 
              : ''),
      'date': DateTime.now(),
      'time': '10:30 AM',
      'budget': '',
      'provider_name': widget.provider?.name ?? 'Marcus Vane',
      'provider_role': widget.provider?.role ?? 'Master Barber',
      'provider_image': widget.provider?.imageUrl ?? 'https://lh3.googleusercontent.com/aida-public/AB6AXuAQY-wJQBD18t4GYQjf_DFHRKKTDMbwPTEdf3y0G3_pnsISu96W29vq7mSX_7ZURbByCaRcP_rwjXjYO-jZ39d-I7PFbj8H7q9lk0z6UDFMsHpTKJPX0LUYEk6HZQPzr9xvCAnMpI8GxGKxTjSZNMYqcmy1Eh5VNKh3loa7SWv2WqNT7MEFGNFATRVabclMw7Qq5uPMRZcpobPAT3CZrA8ovg5y72uAKbEJ2BZxTDmO-i1v2g7Aq-imn2ikZzb3sMuRdbeEL2aXU0qS',
    };
  }

  void _nextStep() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    const neonGreen = Color(0xFF25F46A);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getTitle(_currentStep),
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.05),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: const Icon(Icons.close, color: Colors.grey, size: 20),
                    ),
                  ),
                ],
              ),
            ),

            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                   _buildProgressIndicator(0, neonGreen),
                   const SizedBox(width: 8),
                   _buildProgressIndicator(1, neonGreen),
                   const SizedBox(width: 8),
                   _buildProgressIndicator(2, neonGreen),
                   const SizedBox(width: 16),
                   Text(
                     'STEP ${_currentStep + 1} OF 3',
                     style: GoogleFonts.spaceGrotesk(
                       color: neonGreen,
                       fontSize: 10,
                       fontWeight: FontWeight.w600,
                       letterSpacing: 1,
                     ),
                   ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Disable swipe
                children: [
                  Step1Details(
                    onNext: _nextStep,
                    data: _requestData,
                  ),
                  Step2Schedule(
                    onNext: _nextStep,
                    onPrev: _prevStep,
                    data: _requestData,
                  ),
                  Step3Review(
                    onPrev: _prevStep,
                    data: _requestData,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTitle(int step) {
    switch (step) {
      case 0: return 'New Request';
      case 1: return 'Schedule & Budget';
      case 2: return 'Review Request';
      default: return 'New Request';
    }
  }

  Widget _buildProgressIndicator(int index, Color color) {
    final isActive = index <= _currentStep;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 6,
      width: isActive ? 32 : 12, // Active segments are longer
      decoration: BoxDecoration(
        color: isActive ? color : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(3),
        boxShadow: isActive ? [
           BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 1,
          )
        ] : [],
        border: isActive ? null : Border.all(color: color.withOpacity(0.3)),
      ),
    );
  }
}
