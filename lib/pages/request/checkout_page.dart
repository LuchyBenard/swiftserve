import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import '../tracking/job_tracking_page.dart';

class CheckoutPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const CheckoutPage({super.key, required this.data});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _selectedMethod = 'cash'; // 'cash' or 'bank'

  @override
  Widget build(BuildContext context) {
    const neonGreen = Color(0xFF25F46A);
    final String amount = widget.data['budget']?.toString().replaceAll(RegExp(r'[^0-9.]'), '') ?? '145.00';
    if (!amount.contains('.')) {
      // Add .00 if not present for premium look
    }

    return Scaffold(
      backgroundColor: Colors.black,
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
                color: neonGreen.withOpacity(0.1),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
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

          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        _buildAmountDisplay(neonGreen, amount),
                        const SizedBox(height: 48),
                        _buildPaymentMethods(neonGreen),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
                _buildBottomActions(neonGreen),
              ],
            ),
          ),
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
            'Checkout',
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 44), // Logic to balance the row
        ],
      ),
    );
  }

  Widget _buildAmountDisplay(Color neonGreen, String amount) {
    return Column(
      children: [
        Text(
          'TOTAL AMOUNT',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.grey[500],
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '\$',
                style: GoogleFonts.spaceGrotesk(
                  color: neonGreen,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: neonGreen.withOpacity(0.5), blurRadius: 10)],
                ),
              ),
            ),
            Text(
              amount,
              style: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontSize: 64,
                fontWeight: FontWeight.bold,
                letterSpacing: -2,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, color: Colors.grey[600], size: 14),
            const SizedBox(width: 4),
            Text(
              'Includes platform fee and service taxes',
              style: TextStyle(color: Colors.grey[600], fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMethods(Color neonGreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PAYMENT METHOD',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        
        // Cash on Delivery
        _buildPaymentOption(
          id: 'cash',
          title: 'Cash on Delivery',
          subtitle: 'Pay after service is completed',
          icon: Icons.payments_outlined,
          neonGreen: neonGreen,
        ),
        
        const SizedBox(height: 16),
        
        // Bank Transfer
        _buildPaymentOption(
          id: 'bank',
          title: 'Bank Transfer',
          subtitle: 'Direct deposit to provider',
          icon: Icons.account_balance_outlined,
          neonGreen: neonGreen,
          showDetails: _selectedMethod == 'bank',
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color neonGreen,
    bool showDetails = false,
  }) {
    final bool isSelected = _selectedMethod == id;

    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? neonGreen.withOpacity(0.05) : Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? neonGreen : Colors.white.withOpacity(0.08),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Icon(icon, color: isSelected ? neonGreen : Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? neonGreen : Colors.white.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(color: neonGreen, shape: BoxShape.circle),
                          ),
                        )
                      : null,
                ),
              ],
            ),
            if (showDetails) ...[
              const SizedBox(height: 20),
              Container(height: 1, color: Colors.white.withOpacity(0.1)),
              const SizedBox(height: 20),
              _buildBankDetails(neonGreen),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildBankDetails(Color neonGreen) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ACCOUNT NUMBER', style: GoogleFonts.spaceGrotesk(color: Colors.grey[600], fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  const SizedBox(height: 4),
                  Text(
                    '7740 1293 4810 55',
                    style: GoogleFonts.spaceMono(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(const ClipboardData(text: '77401293481055'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Account number copied!'), duration: Duration(seconds: 1)),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: neonGreen.withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(Icons.content_copy, color: neonGreen, size: 14),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildDetailSubItem('BANK', 'Swift National Bank'),
            const SizedBox(width: 24),
            _buildDetailSubItem('HOLDER', 'John’s Grooming LLC'),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailSubItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.spaceGrotesk(color: Colors.grey[600], fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        const SizedBox(height: 2),
        Text(value, style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildBottomActions(Color neonGreen) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.verified_user_outlined, color: neonGreen, size: 18),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Your payment information is encrypted and secure with 256-bit SSL protection.',
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 64,
            child: ElevatedButton(
              onPressed: () {
                _showSuccessAndNavigate();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: neonGreen,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 10,
                shadowColor: neonGreen.withOpacity(0.4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CONFIRM PAYMENT',
                    style: GoogleFonts.spaceGrotesk(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel Transaction',
              style: GoogleFonts.spaceGrotesk(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessAndNavigate() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment Confirmed! Request Posted.'),
        backgroundColor: Color(0xFF25F46A),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Deep navigation to tracking
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => JobTrackingPage(
          providerName: widget.data['provider_name'] ?? 'Marcus Vane',
          serviceType: widget.data['provider_role'] ?? 'Master Barber',
          providerImageUrl: widget.data['provider_image'] ?? 'https://lh3.googleusercontent.com/aida-public/AB6AXuAQY-wJQBD18t4GYQjf_DFHRKKTDMbwPTEdf3y0G3_pnsISu96W29vq7mSX_7ZURbByCaRcP_rwjXjYO-jZ39d-I7PFbj8H7q9lk0z6UDFMsHpTKJPX0LUYEk6HZQPzr9xvCAnMpI8GxGKxTjSZNMYqcmy1Eh5VNKh3loa7SWv2WqNT7MEFGNFATRVabclMw7Qq5uPMRZcpobPAT3CZrA8ovg5y72uAKbEJ2BZxTDmO-i1v2g7Aq-imn2ikZzb3sMuRdbeEL2aXU0qS',
        ),
      ),
      (route) => route.isFirst, 
    );
  }
}
