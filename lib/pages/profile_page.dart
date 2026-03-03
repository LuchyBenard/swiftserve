import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/provider_bottom_nav.dart';
import 'admin/admin_dashboard_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const neonGreen = Color(0xFF25F46A);
  bool _isProviderMode = false;
  bool _isAdminMode = false;
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  String _selectedLocation = 'Independence Layout';
  
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  final List<String> _enuguLocations = [
    'Independence Layout', 'Achara Layout', 'Trans Ekulu', 'Abakpa', 'Coal Camp',
    'Emene', 'New Haven', 'Thinkers Corner', 'GRA', 'Ogui New Layout',
    'Awkunanaw', 'Gariki', 'Uwani', 'Obiagu', 'Maryland', 'Meniru',
    'Agbani Road', 'Eke-Obinagu', 'Iva Valley', 'Tinker', 'Garki', 'Topland',
    'Amechi'
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Alex Johnson');
    _emailController = TextEditingController(text: 'alex.j@example.com');
    _phoneController = TextEditingController(text: '+234 803 000 0000');
    _bioController = TextEditingController(text: 'Service seeker looking for quality help in Enugu.');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveProfile() {
    setState(() {
      _isEditing = false;
    });
    // In a real app, we would upload to a server here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
           // Optional nice subtle background glow
           Positioned(
             top: -100,
             right: -100,
             child: Container(
               width: 300,
               height: 300,
               decoration: BoxDecoration(
                 shape: BoxShape.circle,
                 color: neonGreen.withValues(alpha: 0.05),
                 boxShadow: [BoxShadow(color: neonGreen.withValues(alpha: 0.05), blurRadius: 100)]
               ),
             ),
           ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // App Bar (Custom)
                  Row(
                    children: [
                       GestureDetector(
                         onTap: () {
                           if (_isEditing) {
                             setState(() => _isEditing = false);
                           } else {
                             Navigator.pop(context);
                           }
                         },
                         child: Icon(_isEditing ? Icons.close : Icons.arrow_back, color: Colors.white)
                       ), 
                       const SizedBox(width: 20),
                       if (_isEditing)
                         Text(
                           'EDIT PROFILE',
                           style: GoogleFonts.spaceGrotesk(
                             color: Colors.white,
                             fontSize: 18,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                       const Spacer(),
                    ],
                  ),
                  
                  const SizedBox(height: 20),

                  // Profile Image with Glow
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      GestureDetector(
                        onTap: _isEditing ? _pickImage : null,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: neonGreen, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: neonGreen.withValues(alpha: 0.4),
                                blurRadius: 30,
                                spreadRadius: 5,
                              )
                            ]
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[900],
                            backgroundImage: _imageFile != null 
                              ? FileImage(_imageFile!) as ImageProvider
                              : const NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80'),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _toggleEdit,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: neonGreen,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(_isEditing ? Icons.check : Icons.edit, color: Colors.black, size: 20),
                        ),
                      )
                    ],
                  ),
                  
                  // Name
                  if (_isEditing)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextField(
                        controller: _nameController,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: neonGreen.withValues(alpha: 0.5))),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: neonGreen)),
                        ),
                      ),
                    )
                  else
                    Text(
                      _nameController.text,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  
                  // Editable Fields and Info
                  const SizedBox(height: 32),
                  
                  if (_isEditing) ...[
                    _buildEditableInput('FULL NAME', _nameController, Icons.person_outline),
                    _buildEditableInput('EMAIL', _emailController, Icons.mail_outline, keyboardType: TextInputType.emailAddress),
                    _buildEditableInput('PHONE', _phoneController, Icons.phone_outlined, keyboardType: TextInputType.phone),
                    _buildEditableInput('BIO', _bioController, Icons.info_outline, maxLines: 3),
                    
                    const SizedBox(height: 16),
                    _buildLabel('LOCATION IN ENUGU'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF101010),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[900]!),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedLocation,
                          dropdownColor: const Color(0xFF101010),
                          isExpanded: true,
                          icon: Icon(Icons.keyboard_arrow_down, color: neonGreen),
                          items: _enuguLocations.map((String loc) {
                            return DropdownMenuItem(
                              value: loc,
                              child: Text(loc, style: GoogleFonts.spaceGrotesk(color: Colors.white)),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedLocation = val!),
                        ),
                      ),
                    ),
                  ] else ...[
                    _buildProfileInfo(Icons.mail_outline, _emailController.text),
                    _buildProfileInfo(Icons.phone_outlined, _phoneController.text),
                    _buildProfileInfo(Icons.location_on_outlined, _selectedLocation),
                    _buildProfileInfo(Icons.info_outline, _bioController.text),
                  ],
                  
                  if (_isEditing) ...[
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: neonGreen,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                        ),
                        child: Text(
                          'SAVE CHANGES',
                          style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 12),
                  
                  // Verified & Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F361C), // Dark green bg
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: neonGreen.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.verified, color: neonGreen, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              'VERIFIED',
                              style: GoogleFonts.spaceGrotesk(
                                color: neonGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.star, color: Colors.white, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '4.9',
                        style: GoogleFonts.spaceGrotesk(
                           color: Colors.white,
                           fontSize: 16,
                           fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' (48)',
                        style: GoogleFonts.spaceGrotesk(color: Colors.grey[500], fontSize: 16),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Switch to Provider
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF101010),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey[900]!),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.storefront, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Switch to Provider',
                                style: GoogleFonts.spaceGrotesk(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'OFFER YOUR SERVICES',
                                style: GoogleFonts.spaceGrotesk(
                                  color: Colors.grey[500],
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _isProviderMode,
                          activeThumbColor: neonGreen,
                          activeTrackColor: neonGreen.withValues(alpha: 0.2),
                          inactiveThumbColor: Colors.grey[400],
                          inactiveTrackColor: Colors.grey[800],
                          onChanged: (val) {
                            setState(() => _isProviderMode = val);
                            if (val) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ProviderBottomNav()),
                              ).then((_) {
                                setState(() => _isProviderMode = false);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Switch to Admin
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF101010),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey[900]!),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Admin Portal',
                                style: GoogleFonts.spaceGrotesk(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'MANAGE PLATFORM',
                                style: GoogleFonts.spaceGrotesk(
                                  color: Colors.grey[500],
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: _isAdminMode,
                          activeThumbColor: neonGreen,
                          activeTrackColor: neonGreen.withValues(alpha: 0.2),
                          inactiveThumbColor: Colors.grey[400],
                          inactiveTrackColor: Colors.grey[800],
                          onChanged: (val) {
                            setState(() => _isAdminMode = val);
                            if (val) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const AdminDashboardPage()),
                              ).then((_) {
                                setState(() => _isAdminMode = false);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Menu Items
                  _buildMenuItem(Icons.event_note, 'My Bookings'),
                  _buildMenuItem(Icons.payment, 'Payment'),
                  _buildMenuItem(Icons.notifications, 'Notifications', hasAlert: true),
                  _buildMenuItem(Icons.help_outline, 'Help & Support'),
                  _buildMenuItem(Icons.lock_outline, 'Security'),
                  
                  const SizedBox(height: 40),
                  
                  // Logout
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {
                         ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text('Logging out...'), duration: Duration(seconds: 1)),
                         );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red.withValues(alpha: 0.5)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        backgroundColor: Colors.red.withValues(alpha: 0.05),
                      ),
                      child: Text(
                        'LOG OUT',
                        style: GoogleFonts.spaceGrotesk(
                          color: const Color(0xFFEB5757),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 100), // Bottom nav space
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF25F46A), size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.spaceGrotesk(color: Colors.grey[400], fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.spaceGrotesk(
          color: Colors.grey[600],
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildEditableInput(String label, TextEditingController controller, IconData icon, {TextInputType? keyboardType, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(label),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF101010),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[900]!),
            ),
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              maxLines: maxLines,
              style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                prefixIcon: Icon(icon, color: Colors.grey[600], size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {bool hasAlert = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF050505),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey[900]!),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF25F46A), size: 24),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            if (hasAlert)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            if (hasAlert) const SizedBox(width: 12),
            Icon(Icons.chevron_right, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }
}
