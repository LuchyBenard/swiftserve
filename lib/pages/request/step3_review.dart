import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'checkout_page.dart';

class Step3Review extends StatefulWidget {
  final VoidCallback onPrev;
  final Map<String, dynamic> data;

  const Step3Review({
    super.key,
    required this.onPrev,
    required this.data,
  });

  @override
  State<Step3Review> createState() => _Step3ReviewState();
}

class _Step3ReviewState extends State<Step3Review> {
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.data['note']);
    _noteController.addListener(() {
      widget.data['note'] = _noteController.text;
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _editDescription() {
    final TextEditingController descController = TextEditingController(text: widget.data['description']);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0F0F0F),
        title: Text('EDIT DESCRIPTION', style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        content: TextField(
          controller: descController,
          maxLines: 3,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Describe your issue...',
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white12)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          TextButton(
            onPressed: () {
              setState(() => widget.data['description'] = descController.text);
              Navigator.pop(context);
            },
            child: const Text('UPDATE', style: TextStyle(color: Color(0xFF25F46A))),
          ),
        ],
      ),
    );
  }

  void _changePayment() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F0F0F),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SELECT PAYMENT METHOD', style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 20),
            _buildPaymentOption('Visa ending in 4242', 'Expires 12/25', Icons.credit_card),
            _buildPaymentOption('Mastercard ending in 8899', 'Expires 05/27', Icons.credit_card),
            _buildPaymentOption('Apple Pay', 'Quick Checkout', Icons.apple),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String title, String subtitle, IconData icon) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      trailing: const Icon(Icons.circle_outlined, color: Colors.grey, size: 18),
      onTap: () {
        setState(() => widget.data['payment_method'] = title);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const neonGreen = Color(0xFF25F46A);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Navigation Row
          GestureDetector(
            onTap: widget.onPrev,
            child: Row(
              children: [
                const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'BACK TO SCHEDULE',
                  style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Glass Card Summary
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'REQUEST SUMMARY',
                            style: GoogleFonts.spaceGrotesk(color: Colors.grey[400], fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
                          ),
                          GestureDetector(
                            onTap: _editDescription,
                            child: Text(
                              'EDIT',
                              style: GoogleFonts.spaceGrotesk(color: neonGreen, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Title & Desc
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF111111),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white.withOpacity(0.1)),
                            ),
                            child: Icon(Icons.description, color: Colors.grey[300]),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Service Request',
                                  style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.data['description']?.toString().isNotEmpty == true 
                                      ? widget.data['description'] 
                                      : 'No description provided',
                                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      Divider(color: Colors.white.withOpacity(0.05)),
                      const SizedBox(height: 16),
                      // Details
                      _buildSummaryRow(Icons.location_on, 'Location', widget.data['location'] ?? 'Independence Layout, Enugu', neonGreen),
                      const SizedBox(height: 16),
                      _buildSummaryRow(
                        Icons.schedule, 
                        'Scheduled Time', 
                        '${(widget.data['date']?.toString() ?? '2026-10-12').split(' ')[0]}, ${widget.data['time'] ?? '10:30 AM'}', 
                        neonGreen
                      ),
                      const SizedBox(height: 16),
                      _buildSummaryRow(Icons.attach_money, 'Estimated Budget', widget.data['budget'] ?? r'$50', neonGreen),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Payment Method
          _buildSectionTitle('PAYMENT METHOD', neonGreen),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111111),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: const Icon(Icons.credit_card, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.data['payment_method'] ?? 'Visa ending in 4242',
                        style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        'Default Method',
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: _changePayment,
                  child: Text(
                    'CHANGE',
                    style: GoogleFonts.spaceGrotesk(color: neonGreen, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Note
          _buildSectionTitle('NOTE FOR PROVIDER (OPTIONAL)', Colors.grey),
          const SizedBox(height: 12),
          TextField(
            controller: _noteController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF0A0A0A),
              hintText: 'Gate code: 1234...',
              hintStyle: TextStyle(color: Colors.grey[600]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: neonGreen),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Confirm Button
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                 // Final Action
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(
                     content: Text('Request Posted Successfully!'),
                     backgroundColor: neonGreen,
                     behavior: SnackBarBehavior.floating,
                   ),
                 );
                 // Navigate to Checkout
                 Navigator.push(
                   context,
                   MaterialPageRoute(
                     builder: (context) => CheckoutPage(data: widget.data),
                   ),
                 );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: neonGreen,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 10,
                shadowColor: neonGreen.withOpacity(0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CONFIRM & POST',
                    style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.check_circle_outline),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          Center(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.grey[600], fontSize: 10),
                children: [
                  const TextSpan(text: 'By posting, you agree to SwiftServe\'s '),
                  TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(color: Colors.grey[500], decoration: TextDecoration.underline),
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Row(
      children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 10)),
            Text(value, style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14)),
          ],
        )
      ],
    );
  }
}
