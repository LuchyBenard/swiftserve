import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/provider_filter.dart';

class ProviderFilterSheet extends StatefulWidget {
  final ProviderFilter initialFilter;
  final ValueChanged<ProviderFilter> onApply;

  const ProviderFilterSheet({
    super.key,
    required this.initialFilter,
    required this.onApply,
  });

  static Future<void> show({
    required BuildContext context,
    required ProviderFilter currentFilter,
    required ValueChanged<ProviderFilter> onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProviderFilterSheet(
        initialFilter: currentFilter,
        onApply: onApply,
      ),
    );
  }

  @override
  State<ProviderFilterSheet> createState() => _ProviderFilterSheetState();
}

class _ProviderFilterSheetState extends State<ProviderFilterSheet> {
  late double? _minRating;
  late double? _maxPrice;
  late bool _availableToday;
  late double? _maxDistance;
  late String _sortBy;

  @override
  void initState() {
    super.initState();
    _minRating = widget.initialFilter.minRating;
    _maxPrice = widget.initialFilter.maxPrice;
    _availableToday = widget.initialFilter.availableToday;
    _maxDistance = widget.initialFilter.maxDistance;
    _sortBy = widget.initialFilter.sortBy;
  }

  void _reset() {
    setState(() {
      _minRating = null;
      _maxPrice = null;
      _availableToday = false;
      _maxDistance = null;
      _sortBy = 'rating';
    });
  }

  void _apply() {
    final updated = widget.initialFilter.copyWith(
      minRating: _minRating,
      clearMinRating: _minRating == null,
      maxPrice: _maxPrice,
      clearMaxPrice: _maxPrice == null,
      availableToday: _availableToday,
      maxDistance: _maxDistance,
      clearMaxDistance: _maxDistance == null,
      sortBy: _sortBy,
    );
    widget.onApply(updated);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF25F46A);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F0F0F),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.tune, color: primaryGreen, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'Filter & Sort',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: _reset,
                child: Text(
                  'Reset',
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.grey[400],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Available Today Toggle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF161616),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bolt, color: primaryGreen, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      'Available Today',
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Switch(
                  value: _availableToday,
                  activeColor: primaryGreen,
                  onChanged: (val) => setState(() => _availableToday = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Minimum Rating
          Text(
            'MINIMUM RATING',
            style: GoogleFonts.spaceGrotesk(
              color: Colors.grey[400],
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildRatingChip('Any', null, primaryGreen),
              const SizedBox(width: 8),
              _buildRatingChip('4.0+ ★', 4.0, primaryGreen),
              const SizedBox(width: 8),
              _buildRatingChip('4.5+ ★', 4.5, primaryGreen),
              const SizedBox(width: 8),
              _buildRatingChip('4.8+ ★', 4.8, primaryGreen),
            ],
          ),
          const SizedBox(height: 20),

          // Price Range
          Text(
            'PRICE CAP (STARTING PRICE)',
            style: GoogleFonts.spaceGrotesk(
              color: Colors.grey[400],
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildPriceChip('Any Price', null, primaryGreen),
              _buildPriceChip('Under \$40', 40.0, primaryGreen),
              _buildPriceChip('Under \$60', 60.0, primaryGreen),
              _buildPriceChip('Under \$100', 100.0, primaryGreen),
            ],
          ),
          const SizedBox(height: 20),

          // Distance
          Text(
            'MAXIMUM DISTANCE',
            style: GoogleFonts.spaceGrotesk(
              color: Colors.grey[400],
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildDistanceChip('Anywhere', null, primaryGreen),
              _buildDistanceChip('< 1.0 mi', 1.0, primaryGreen),
              _buildDistanceChip('< 2.0 mi', 2.0, primaryGreen),
              _buildDistanceChip('< 5.0 mi', 5.0, primaryGreen),
            ],
          ),
          const SizedBox(height: 20),

          // Sort By
          Text(
            'SORT BY',
            style: GoogleFonts.spaceGrotesk(
              color: Colors.grey[400],
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSortChip('Top Rated', 'rating', primaryGreen),
              _buildSortChip('Lowest Price', 'price_low', primaryGreen),
              _buildSortChip('Highest Price', 'price_high', primaryGreen),
              _buildSortChip('Nearest Distance', 'distance', primaryGreen),
            ],
          ),
          const SizedBox(height: 28),

          // Apply Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _apply,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                'Apply Filters',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingChip(String label, double? val, Color primaryGreen) {
    final selected = _minRating == val;
    return GestureDetector(
      onTap: () => setState(() => _minRating = val),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? primaryGreen : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? primaryGreen : Colors.white12),
        ),
        child: Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            color: selected ? Colors.black : Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPriceChip(String label, double? val, Color primaryGreen) {
    final selected = _maxPrice == val;
    return GestureDetector(
      onTap: () => setState(() => _maxPrice = val),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? primaryGreen : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? primaryGreen : Colors.white12),
        ),
        child: Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            color: selected ? Colors.black : Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDistanceChip(String label, double? val, Color primaryGreen) {
    final selected = _maxDistance == val;
    return GestureDetector(
      onTap: () => setState(() => _maxDistance = val),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? primaryGreen : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? primaryGreen : Colors.white12),
        ),
        child: Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            color: selected ? Colors.black : Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSortChip(String label, String val, Color primaryGreen) {
    final selected = _sortBy == val;
    return GestureDetector(
      onTap: () => setState(() => _sortBy = val),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? primaryGreen : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? primaryGreen : Colors.white12),
        ),
        child: Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            color: selected ? Colors.black : Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
