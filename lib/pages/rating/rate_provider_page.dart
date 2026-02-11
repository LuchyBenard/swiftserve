import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RateProviderPage extends StatefulWidget {
  final String providerName;
  final String providerRole;
  final String providerImageUrl;
  final String serviceDescription;

  const RateProviderPage({
    super.key,
    this.providerName = 'Marcus Vane',
    this.providerRole = 'Master Barber',
    this.providerImageUrl = 'https://lh3.googleusercontent.com/aida-public/AB6AXuCqaZ7wk8boFIodQC_72x7gFRiF-KA6YLJuS5oG787ow5E6cLDav6l_BvN9b8MFowza2zKonigLZuY4910ShpjHQLW9A7Fj_7k6AMzI0JNMBa1EOrExgnZr_W-t9OZWd02hW3qIm5zf3KHs_Opa9s_8_0MeRGhiLbBxE2owIqQY84oOJOEsTnjK3hkyVvq9ZcrEhEgDCgilg-b8o7f2kH-IhMntmDQcIhOIU54NJFLtCj-XVoZVmtQoEdxEm2dI5zYAJ18MQ_JQ2d6b',
    this.serviceDescription = 'Platinum Cut & Style',
  });

  @override
  State<RateProviderPage> createState() => _RateProviderPageState();
}

class _RateProviderPageState extends State<RateProviderPage> {
  int _currentRating = 4;
  final List<String> _quickFeedbackOptions = [
    'Punctual',
    'Professional',
    'Expert',
    'Clean Setup',
    'Great Value',
  ];
  final Set<String> _selectedFeedback = {'Punctual', 'Professional', 'Great Value'};
  final TextEditingController _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const neonGreen = Color(0xFF25F46A);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: 100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: neonGreen.withOpacity(0.05),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: 200,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: neonGreen.withOpacity(0.05),
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
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        _buildProfileSection(neonGreen),
                        const SizedBox(height: 48),
                        _buildRatingSection(neonGreen),
                        const SizedBox(height: 48),
                        _buildReviewInput(neonGreen),
                        const SizedBox(height: 32),
                        _buildQuickFeedback(neonGreen),
                        const SizedBox(height: 120), // Space for button
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Submit Button
          _buildSubmitButton(neonGreen),
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
              child: const Icon(Icons.chevron_left, color: Colors.white, size: 24),
            ),
          ),
          Text(
            'Rate Service Provider',
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildProfileSection(Color neonGreen) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer Glow
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: neonGreen.withOpacity(0.2),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
            // Avatar Container
            Container(
              width: 144,
              height: 144,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: neonGreen, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(72),
                child: Image.network(
                  widget.providerImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Role Badge
            Positioned(
              bottom: -5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: neonGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.providerRole.toUpperCase(),
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          widget.providerName,
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Service completed: ${widget.serviceDescription}',
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSection(Color neonGreen) {
    return Column(
      children: [
        Text(
          'HOW WAS YOUR SERVICE?',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.grey[500],
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final int starValue = index + 1;
            final bool isSelected = _currentRating >= starValue;
            
            return GestureDetector(
              onTap: () => setState(() => _currentRating = starValue),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  Icons.star,
                  size: 44,
                  color: isSelected ? neonGreen : Colors.grey[900],
                  shadows: isSelected ? [
                    Shadow(color: neonGreen.withOpacity(0.8), blurRadius: 15),
                  ] : null,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildReviewInput(Color neonGreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WRITE A REVIEW',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.grey[500],
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: neonGreen.withOpacity(0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: neonGreen.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: TextField(
            controller: _reviewController,
            maxLines: 5,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Tell us about your experience with ${widget.providerName.split(' ')[0]}...',
              hintStyle: TextStyle(color: Colors.grey[800]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickFeedback(Color neonGreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QUICK FEEDBACK',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.grey[500],
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _quickFeedbackOptions.map((option) {
            final isSelected = _selectedFeedback.contains(option);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedFeedback.remove(option);
                  } else {
                    _selectedFeedback.add(option);
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? neonGreen.withOpacity(0.1) : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected ? neonGreen.withOpacity(0.5) : Colors.white.withOpacity(0.1),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Text(
                  option,
                  style: GoogleFonts.spaceGrotesk(
                    color: isSelected ? neonGreen : Colors.grey[500],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(Color neonGreen) {
    return Positioned(
      bottom: 40,
      left: 24,
      right: 24,
      child: GestureDetector(
        onTap: () {
          _handleSubmit(neonGreen);
        },
        child: Container(
          height: 64,
          width: double.infinity,
          decoration: BoxDecoration(
            color: neonGreen,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: neonGreen.withOpacity(0.4),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'SUBMIT REVIEW',
              style: GoogleFonts.spaceGrotesk(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmit(Color neonGreen) {
    // Logic for submission
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Review Submitted Successfully!',
          style: GoogleFonts.spaceGrotesk(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: neonGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
    
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }
}
