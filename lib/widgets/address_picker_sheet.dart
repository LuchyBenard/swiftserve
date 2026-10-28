import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/saved_address.dart';
import '../services/address_service.dart';

class AddressPickerSheet extends StatefulWidget {
  final ValueChanged<SavedAddress>? onAddressSelected;

  const AddressPickerSheet({super.key, this.onAddressSelected});

  static Future<SavedAddress?> show({
    required BuildContext context,
    ValueChanged<SavedAddress>? onAddressSelected,
  }) {
    return showModalBottomSheet<SavedAddress>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddressPickerSheet(onAddressSelected: onAddressSelected),
    );
  }

  @override
  State<AddressPickerSheet> createState() => _AddressPickerSheetState();
}

class _AddressPickerSheetState extends State<AddressPickerSheet> {
  final AddressService _addressService = AddressService();
  bool _isDetectingGps = false;
  bool _isAddingNew = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _addressLineController = TextEditingController();
  String _selectedTag = 'home';

  @override
  void initState() {
    super.initState();
    _addressService.init();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _addressLineController.dispose();
    super.dispose();
  }

  Future<void> _handleGpsDetect() async {
    setState(() => _isDetectingGps = true);
    try {
      final detected = await _addressService.detectCurrentGPSLocation();
      widget.onAddressSelected?.call(detected);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('📍 Location updated via GPS!'),
            backgroundColor: Color(0xFF25F46A),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context, detected);
      }
    } finally {
      if (mounted) setState(() => _isDetectingGps = false);
    }
  }

  Future<void> _handleSaveNewAddress() async {
    final title = _titleController.text.trim();
    final addressLine = _addressLineController.text.trim();

    if (title.isEmpty || addressLine.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both title and address'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final newAddress = SavedAddress(
      id: 'addr_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      addressLine: addressLine,
      tag: _selectedTag,
    );

    await _addressService.addAddress(newAddress);
    widget.onAddressSelected?.call(newAddress);

    if (mounted) {
      Navigator.pop(context, newAddress);
    }
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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: primaryGreen, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Select Service Location',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white54, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // GPS Auto Detect Button
          GestureDetector(
            onTap: _isDetectingGps ? null : _handleGpsDetect,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF161616),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primaryGreen.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  _isDetectingGps
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: primaryGreen),
                        )
                      : const Icon(Icons.my_location, color: primaryGreen, size: 22),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isDetectingGps ? 'Detecting coordinates...' : 'Auto-Detect via GPS',
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Use device satellite position in Enugu',
                          style: GoogleFonts.spaceGrotesk(color: Colors.grey[500], fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white30, size: 14),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Saved Addresses Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SAVED ADDRESSES',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.grey[400],
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _isAddingNew = !_isAddingNew),
                child: Text(
                  _isAddingNew ? 'Cancel' : '+ Add New',
                  style: GoogleFonts.spaceGrotesk(
                    color: primaryGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Inline Add Form
          if (_isAddingNew) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF161616),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Label (e.g. Home, Studio, Mom\'s House)',
                      hintStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _addressLineController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Full Address & Landmark in Enugu',
                      hintStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _buildTagChip('home', Icons.home, primaryGreen),
                      const SizedBox(width: 8),
                      _buildTagChip('work', Icons.work, primaryGreen),
                      const SizedBox(width: 8),
                      _buildTagChip('other', Icons.place, primaryGreen),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _handleSaveNewAddress,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Addresses List
          ValueListenableBuilder<List<SavedAddress>>(
            valueListenable: _addressService.addressesNotifier,
            builder: (context, addresses, _) {
              return ValueListenableBuilder<SavedAddress?>(
                valueListenable: _addressService.selectedAddressNotifier,
                builder: (context, selected, _) {
                  return Column(
                    children: addresses.map((addr) {
                      final isSelected = selected?.id == addr.id;
                      return _buildAddressTile(addr, isSelected, primaryGreen);
                    }).toList(),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTagChip(String tag, IconData icon, Color primaryGreen) {
    final selected = _selectedTag == tag;
    return GestureDetector(
      onTap: () => setState(() => _selectedTag = tag),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? primaryGreen : const Color(0xFF222222),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: selected ? Colors.black : Colors.white70),
            const SizedBox(width: 4),
            Text(
              tag.toUpperCase(),
              style: TextStyle(
                color: selected ? Colors.black : Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressTile(SavedAddress address, bool isSelected, Color primaryGreen) {
    IconData icon;
    switch (address.tag) {
      case 'work':
        icon = Icons.work_outline;
        break;
      case 'home':
        icon = Icons.home_outlined;
        break;
      default:
        icon = Icons.location_on_outlined;
    }

    return GestureDetector(
      onTap: () async {
        await _addressService.selectAddress(address);
        widget.onAddressSelected?.call(address);
        if (mounted) Navigator.pop(context, address);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF19251E) : const Color(0xFF141414),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? primaryGreen : Colors.white10,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? primaryGreen.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isSelected ? primaryGreen : Colors.white70, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        address.title,
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (address.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('DEFAULT', style: TextStyle(color: Colors.white60, fontSize: 8)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    address.addressLine,
                    style: GoogleFonts.spaceGrotesk(color: Colors.grey[400], fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: primaryGreen, size: 20),
          ],
        ),
      ),
    );
  }
}
