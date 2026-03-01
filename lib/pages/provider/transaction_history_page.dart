import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF25F46A);
    const pitchBlack = Color(0xFF050505);

    final List<Map<String, dynamic>> transactions = [
      {"title": "Haircut & Beard Trim", "name": "Client: David Miller", "time": "2 hours ago", "amount": "+\$45.00", "icon": Icons.content_cut},
      {"title": "Style Consultation", "name": "Client: Sarah Jenkins", "time": "Yesterday", "amount": "+\$25.00", "icon": Icons.brush},
      {"title": "Premium Fade", "name": "Client: Mike Ross", "time": "Yesterday", "amount": "+\$35.00", "icon": Icons.content_cut},
      {"title": "Head Shave", "name": "Client: Alex Chen", "time": "Oct 24", "amount": "+\$30.00", "icon": Icons.face},
      {"title": "Beard Grooming", "name": "Client: Linda Wu", "time": "Oct 22", "amount": "+\$20.00", "icon": Icons.face_retouching_natural},
      {"title": "Skin Fade", "name": "Client: John Doe", "time": "Oct 20", "amount": "+\$40.00", "icon": Icons.content_cut},
      {"title": "Kid's Haircut", "name": "Client: Robert Fox", "time": "Oct 18", "amount": "+\$25.00", "icon": Icons.child_care},
    ];

    return Scaffold(
      backgroundColor: pitchBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Transaction History",
          style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final tx = transactions[index];
          return _buildTransactionItem(
            tx["title"], tx["name"], tx["time"], tx["amount"], tx["icon"], primaryGreen
          );
        },
      ),
    );
  }

  Widget _buildTransactionItem(String title, String name, String time, String amount, IconData icon, Color primaryGreen) {
    return Container(
      margin: const EdgeInsets.all(0).copyWith(bottom: 12),
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
              color: const Color(0xFF0F1A12),
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
                  "$name • $time",
                  style: TextStyle(color: Colors.grey[500], fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.spaceGrotesk(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
