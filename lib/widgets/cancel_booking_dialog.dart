import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CancelBookingDialog extends StatefulWidget {
  final String providerName;
  final String serviceType;

  const CancelBookingDialog({
    super.key,
    required this.providerName,
    required this.serviceType,
  });

  static Future<String?> show({
    required BuildContext context,
    required String providerName,
    required String serviceType,
  }) {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (context) => CancelBookingDialog(
        providerName: providerName,
        serviceType: serviceType,
      ),
    );
  }

  @override
  State<CancelBookingDialog> createState() => _CancelBookingDialogState();
}

class _CancelBookingDialogState extends State<CancelBookingDialog> {
  final List<String> _reasons = [
    'Schedule conflict / Need to reschedule',
    'Found an alternative provider',
    'Provider delayed or unresponsive',
    'Price or budget disagreement',
    'Booked by mistake',
    'Other reason',
  ];

  String _selectedReason = 'Schedule conflict / Need to reschedule';
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const dangerRed = Color(0xFFFF5252);

    return Dialog(
      backgroundColor: const Color(0xFF121212),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: const BorderSide(color: Colors.white12),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon & Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: dangerRed.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.cancel_outlined, color: dangerRed, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cancel Booking',
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.providerName} • ${widget.serviceType}',
                        style: GoogleFonts.spaceGrotesk(color: Colors.grey[400], fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Text(
              'Please select a reason for canceling:',
              style: GoogleFonts.spaceGrotesk(color: Colors.grey[300], fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            // Reasons List
            Column(
              children: _reasons.map((reason) {
                final isSelected = _selectedReason == reason;
                return GestureDetector(
                  onTap: () => setState(() => _selectedReason = reason),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF221515) : const Color(0xFF181818),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? dangerRed.withValues(alpha: 0.6) : Colors.white10,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                          color: isSelected ? dangerRed : Colors.grey[600],
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            reason,
                            style: GoogleFonts.spaceGrotesk(
                              color: isSelected ? Colors.white : Colors.grey[400],
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            // Additional Notes Input
            TextField(
              controller: _notesController,
              maxLines: 2,
              style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Additional details (optional)...',
                hintStyle: GoogleFonts.spaceGrotesk(color: Colors.grey[600], fontSize: 12),
                filled: true,
                fillColor: const Color(0xFF181818),
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.white10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.white10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: dangerRed),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Policy notice
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.grey, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your booking will be released and payment refunded per cancellation terms.',
                      style: GoogleFonts.spaceGrotesk(color: Colors.grey[500], fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Actions
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Keep Booking',
                      style: GoogleFonts.spaceGrotesk(color: Colors.grey[400], fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final notes = _notesController.text.trim();
                      final fullReason = notes.isNotEmpty ? '$_selectedReason ($notes)' : _selectedReason;
                      Navigator.pop(context, fullReason);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: dangerRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      'Cancel Booking',
                      style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
