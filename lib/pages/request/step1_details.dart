import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Step1Details extends StatefulWidget {
  final VoidCallback onNext;
  final Map<String, dynamic> data;

  const Step1Details({super.key, required this.onNext, required this.data});

  @override
  State<Step1Details> createState() => _Step1DetailsState();
}

class _Step1DetailsState extends State<Step1Details> {
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(
      text: widget.data['description'] as String? ?? '',
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _continue() {
    final description = _descriptionController.text.trim();
    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please describe what you need help with.'),
        ),
      );
      return;
    }

    widget.data['description'] = description;
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    const neonGreen = Color(0xFF25F46A);
    final providerName =
        widget.data['provider_name'] as String? ?? 'SwiftServe Pro';
    final providerRole =
        widget.data['provider_role'] as String? ?? 'Service Professional';
    final providerImage = widget.data['provider_image'] as String? ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF101010),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: providerImage.isNotEmpty
                      ? Image.network(
                          providerImage,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildAvatarPlaceholder(neonGreen),
                        )
                      : _buildAvatarPlaceholder(neonGreen),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        providerName,
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        providerRole,
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: neonGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'SELECTED',
                    style: GoogleFonts.spaceGrotesk(
                      color: neonGreen,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Describe the issue',
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Share as much detail as possible so your provider can arrive prepared.',
            style: GoogleFonts.spaceGrotesk(
              color: Colors.grey[500],
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _descriptionController,
            maxLines: 5,
            onChanged: (value) => widget.data['description'] = value,
            style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'e.g. My kitchen sink is leaking under the cabinet...',
              hintStyle: GoogleFonts.spaceGrotesk(
                color: Colors.grey[600],
                fontSize: 13,
              ),
              filled: true,
              fillColor: const Color(0xFF101010),
              contentPadding: const EdgeInsets.all(16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: neonGreen),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: neonGreen.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: neonGreen.withValues(alpha: 0.15)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.tips_and_updates_outlined,
                  color: neonGreen,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Include the service type, any access instructions, and how urgent the job is.',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.grey[300],
                      fontSize: 11,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _continue,
              style: ElevatedButton.styleFrom(
                backgroundColor: neonGreen,
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'CONTINUE',
                style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarPlaceholder(Color neonGreen) {
    return Container(
      width: 56,
      height: 56,
      color: const Color(0xFF1A1A1A),
      child: Icon(Icons.person, color: neonGreen, size: 26),
    );
  }
}
