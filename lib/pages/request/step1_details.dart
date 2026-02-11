import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class Step1Details extends StatefulWidget {
  final VoidCallback onNext;
  final Map<String, dynamic> data;

  const Step1Details({super.key, required this.onNext, required this.data});

  @override
  State<Step1Details> createState() => _Step1DetailsState();
}

class _Step1DetailsState extends State<Step1Details> {
  late TextEditingController _descController;
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedImages = [];

  @override
  void initState() {
    super.initState();
    _descController = TextEditingController(text: widget.data['description']);
    _descController.addListener(() {
       widget.data['description'] = _descController.text;
    });
    // Initialize images if they exist
    if (widget.data['images'] != null) {
      _selectedImages = List<XFile>.from(widget.data['images']);
    }
  }

  Future<void> _pickImage() async {
    if (_selectedImages.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 3 photos allowed')),
      );
      return;
    }
    
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImages.add(image);
        widget.data['images'] = _selectedImages;
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
      widget.data['images'] = _selectedImages;
    });
  }

  void _showLocationDialog() {
    final List<String> neighborhoods = [
      'Independence Layout',
      'Trans Ekulu',
      'Enugu GRA',
      'Abakpa Nike',
      'New Haven',
      'Achara Layout',
      'Uwani',
      'Emene',
      'Coal Camp',
      'Thinkers Corner',
      'Ogui New Layout',
      'Amechi Awkunanaw',
      'Gariki',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F0F0F),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final String currentSearch = widget.data['_locationSearch'] ?? '';
          final filteredList = neighborhoods
              .where((n) => n.toLowerCase().contains(currentSearch.toLowerCase()))
              .toList();

          return Container(
            padding: EdgeInsets.only(
              left: 24, 
              right: 24, 
              top: 32, 
              bottom: MediaQuery.of(context).viewInsets.bottom + 32,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SELECT YOUR AREA',
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white54),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Currently available in Enugu',
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Search field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: TextField(
                    onChanged: (val) {
                      setModalState(() {
                        widget.data['_locationSearch'] = val;
                      });
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search for your neighborhood...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      prefixIcon: const Icon(Icons.search, color: Colors.white54),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),

                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      // List of neighborhoods
                      ...filteredList.map((name) {
                        final isSelected = widget.data['location']?.contains(name) ?? false;
                        return Column(
                          children: [
                            ListTile(
                              onTap: () {
                                setState(() {
                                  widget.data['location'] = '$name, Enugu';
                                  widget.data['_locationSearch'] = null;
                                });
                                Navigator.pop(context);
                              },
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                name,
                                style: GoogleFonts.spaceGrotesk(
                                  color: isSelected ? const Color(0xFF25F46A) : Colors.white,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              trailing: isSelected 
                                ? const Icon(Icons.check_circle, color: Color(0xFF25F46A))
                                : Icon(Icons.chevron_right, color: Colors.grey[800]),
                            ),
                            Divider(color: Colors.white.withOpacity(0.05), height: 1),
                          ],
                        );
                      }).toList(),

                      // Custom location option if search is active and not an exact match
                      if (currentSearch.isNotEmpty && !neighborhoods.any((n) => n.toLowerCase() == currentSearch.toLowerCase()))
                        ListTile(
                          onTap: () {
                            setState(() {
                              widget.data['location'] = '$currentSearch, Enugu';
                              widget.data['_locationSearch'] = null;
                            });
                            Navigator.pop(context);
                          },
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.add_location_alt, color: Color(0xFF25F46A)),
                          title: Text(
                            'Use "$currentSearch"',
                            style: GoogleFonts.spaceGrotesk(
                              color: const Color(0xFF25F46A),
                              fontWeight: FontWeight.bold,
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
      ),
    );
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const neonGreen = Color(0xFF25F46A);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Describe Issue
          _buildSectionTitle('DESCRIBE THE ISSUE', neonGreen),
          const SizedBox(height: 12),
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A0A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: neonGreen, width: 2),
              boxShadow: [
                BoxShadow(
                  color: neonGreen.withOpacity(0.1),
                  blurRadius: 15,
                  spreadRadius: 2,
                )
              ]
            ),
            child: TextField(
              controller: _descController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'I need help with...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                contentPadding: const EdgeInsets.all(20),
              ),
            ),
          ),

          const SizedBox(height: 32),

          _buildSectionTitle('ADD PHOTOS', neonGreen),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Add Button
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: neonGreen.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: CustomPaint(
                       painter: DashedBorderPainter(color: neonGreen),
                       child: Center(
                         child: Icon(Icons.add_a_photo_outlined, color: neonGreen, size: 32),
                       ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Picked Images
                ...List.generate(_selectedImages.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                            image: DecorationImage(
                              image: FileImage(File(_selectedImages[index].path)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                              child: const Icon(Icons.close, color: Colors.white, size: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                // Placeholders if less than 3 total items (Add button + picked images)
                if (_selectedImages.length < 2)
                  ...List.generate(2 - _selectedImages.length, (index) => 
                     Padding(padding: const EdgeInsets.only(right: 16), child: _buildPhotoPlaceholder())
                  ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Location
          _buildSectionTitle('LOCATION', neonGreen),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _showLocationDialog,
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                  color: const Color(0xFF0F0F0F),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Stack(
                children: [
                   // Background Map Pattern
                   Positioned.fill(
                      child: Opacity(
                          opacity: 0.1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.network(
                              'https://upload.wikimedia.org/wikipedia/commons/e/ec/World_map_blank_without_borders.svg',
                              fit: BoxFit.cover,
                              errorBuilder: (c,e,s) => Container(color: Colors.grey[900]),
                            ),
                          ),
                      )
                   ),

                   // Marker
                   Center(
                     child: Column(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                           Icon(Icons.location_on, color: neonGreen, size: 40),
                           Container(
                             width: 20, height: 4,
                             decoration: BoxDecoration(
                                 color: neonGreen.withOpacity(0.5),
                                 borderRadius: BorderRadius.circular(10),
                                 boxShadow: [BoxShadow(color: neonGreen, blurRadius: 10)]
                             ),
                           )
                       ],
                     ),
                   ),

                   // Bottom Overlay
                   Align(
                     alignment: Alignment.bottomCenter,
                     child: Container(
                       margin: const EdgeInsets.all(12),
                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                       decoration: BoxDecoration(
                         color: Colors.black.withOpacity(0.8),
                         borderRadius: BorderRadius.circular(16),
                         border: Border.all(color: Colors.white.withOpacity(0.1)),
                       ),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Row(
                             children: [
                               Icon(Icons.my_location, color: neonGreen, size: 16),
                               const SizedBox(width: 8),
                               Expanded(
                                 child: Text(
                                   widget.data['location'] ?? 'Independence Layout, Enugu',
                                   style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),
                                   maxLines: 1,
                                   overflow: TextOverflow.ellipsis,
                                 ),
                               )
                             ],
                           ),
                           const SizedBox(width: 8),
                           GestureDetector(
                             onTap: _showLocationDialog,
                             child: Text(
                                 'CHANGE',
                                 style: GoogleFonts.spaceGrotesk(color: neonGreen, fontWeight: FontWeight.bold, fontSize: 10),
                             ),
                           )
                         ],
                       ),
                     ),
                   )
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Next Button
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: widget.onNext,
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
                    'NEXT STEP',
                    style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward),
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

  Widget _buildPhotoPlaceholder() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Center(
        child: Icon(Icons.image, color: Colors.grey[800], size: 32),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  DashedBorderPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path()..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0,0,size.width,size.height), const Radius.circular(24)));
    
    // Simple dash implementation
    final dashPath = Path();
    double dashWidth = 5;
    double dashSpace = 5;
    double distance = 0;
    for (PathMetric measurePath in path.computeMetrics()) {
      while (distance < measurePath.length) {
        dashPath.addPath(measurePath.extractPath(distance, distance + dashWidth), Offset.zero);
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
