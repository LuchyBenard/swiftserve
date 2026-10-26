import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminUserManagementPage extends StatefulWidget {
  const AdminUserManagementPage({super.key});

  @override
  State<AdminUserManagementPage> createState() => _AdminUserManagementPageState();
}

class _AdminUserManagementPageState extends State<AdminUserManagementPage> {
  bool _isCustomerView = true;
  String? _selectedUserId;

  final List<Map<String, dynamic>> _customers = [
    {
      'id': 'CUS-8829',
      'name': 'Liam Henderson',
      'joined': 'Oct 12',
      'orders': 12,
      'rating': 4.8,
      'status': 'ACTIVE',
      'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBuVtcfzXwBU4z70kX8vVBSyuBdZeWN28CRuY_7YKFfhDvXHOY3bllU7FzAf3k2pLMV08qtGkSyx5AK3-uttf9bjVudAzJLGSqr1uHiKmWHX7oSm2Dwa_ApZ7W290WcagpYgWOKCaJSUYBbeHzRf1L-UpvKCj7yMM2iDSc_B8hQJ4zg0W0-cAHH1T09wJhZdvq9kWvmLsMSeskahVP3WakotihRx1OVHmVMrCkuIlwabEHolx6o4Kp661IjQBpHMfkYlg7uhL72GFO1',
    },
    {
      'id': 'CUS-9102',
      'name': 'Sarah Chen',
      'joined': 'Today',
      'orders': 0,
      'rating': 0.0,
      'status': 'PENDING',
      'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBn4nKIscAIOzX-Y1a_CsBioivy1ikFc3eaO1b_PgEgVToid3c0hBG-9LZ7nQ94sHK6llKVpa8bNZD3vY-LP-VxK9Qo2_S4w3MdOg6qw-mt7hdrW3vIkwlYZfkZ75yLHxIo5pmV-U4rXQkonBAPATOYIRTIJUyxK8WFVeW3uDW5YjI5bu1xgZuyNbtO0r1rUhS_-7a-zfMit5us41uR69R7mnXWK61bEu1poLwrkCyHjKtifCzcJX3TLjLso7q72NIClLBi0pi4HUSB',
    },
    {
      'id': 'CUS-1102',
      'name': 'Marcus Johnson',
      'joined': 'Aug 22',
      'orders': 5,
      'rating': 3.2,
      'status': 'SUSPENDED',
      'avatar': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDz4bd1OdZnrbYJzN88VunsqUl9YO7g79JE5PUaKbVQ2ukfITwV5tsYAMQUPtrU6CLiVQ-j8Ez-ZRhT1gIwvDz-H2xOlftMBkKqGpzdxyxVFb3u3Pa3u_5VmQlU5i3X_dYr0mcMylrmtUjAwQhD7-TdfgH6zBih9xzAw1PCQ7Vxzdpb2hSv3sFQm0Gk2kOu1-1wiedGfff0tTQ8H-npegj-8wDHr13fxK9z2JGqavWBEMKW0ITYSwvd_td1_p8U-VgH4WlPS-krTWHk',
    },
  ];

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF25F46A);
    const backgroundDark = Color(0xFF102216);
    const pitchBlack = Color(0xFF050B07);

    return Scaffold(
      backgroundColor: backgroundDark,
      body: Stack(
        children: [
          // Background UI
          SafeArea(
            child: Column(
              children: [
                _buildHeader(primaryGreen),
                Expanded(
                  child: _buildUserList(primaryGreen, pitchBlack),
                ),
              ],
            ),
          ),

          // Action Menu (Simulated slide-up)
          if (_selectedUserId != null)
            _buildActionMenu(primaryGreen, pitchBlack),

          // Floating Action Button
          Positioned(
            bottom: 32,
            right: 24,
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: primaryGreen,
              elevation: 10,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.black, size: 28),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Color primary) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Admin Console',
                    style: GoogleFonts.spaceGrotesk(
                      color: primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'SWIFTSERVE MANAGEMENT',
                    style: GoogleFonts.spaceGrotesk(
                      color: primary.withValues(alpha: 0.6),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.notifications, color: primary, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Search Bar
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primary.withValues(alpha: 0.3)),
            ),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search users, email, ID...',
                hintStyle: GoogleFonts.spaceGrotesk(color: Colors.grey[600]),
                prefixIcon: Icon(Icons.search, color: primary.withValues(alpha: 0.5)),
                suffixIcon: Icon(Icons.tune, color: primary.withValues(alpha: 0.5), size: 18),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Segmented Control
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                _buildSegmentButton('Customers', _isCustomerView, primary, () {
                  setState(() => _isCustomerView = true);
                }),
                _buildSegmentButton('Providers', !_isCustomerView, primary, () {
                  setState(() => _isCustomerView = false);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton(String label, bool isActive, Color primary, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive ? [BoxShadow(color: primary.withValues(alpha: 0.4), blurRadius: 10)] : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceGrotesk(
              color: isActive ? Colors.black : Colors.grey[500],
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserList(Color primary, Color pitchBlack) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _customers.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.spaceGrotesk(color: Colors.grey[400], fontSize: 13),
                    children: [
                      const TextSpan(text: 'Showing '),
                      TextSpan(text: '${_customers.length}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      const TextSpan(text: ' customers'),
                    ],
                  ),
                ),
                Text(
                  'Sort by: Date',
                  style: GoogleFonts.spaceGrotesk(
                    color: primary.withValues(alpha: 0.7),
                    fontSize: 11,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.dashed,
                  ),
                ),
              ],
            ),
          );
        }
        final user = _customers[index - 1];
        return _buildUserCard(user, primary, pitchBlack);
      },
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user, Color primary, Color pitchBlack) {
    Color statusColor;
    if (user['status'] == 'ACTIVE') {
      statusColor = primary;
    } else if (user['status'] == 'PENDING') {
      statusColor = Colors.orangeAccent;
    } else {
      statusColor = Colors.redAccent;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: pitchBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          user['avatar'],
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: -1,
                        right: -1,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: pitchBlack, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['name'],
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'ID: ${user['id']} • Joined ${user['joined']}',
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.grey[600],
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: statusColor.withValues(alpha: 0.2)),
                ),
                child: Text(
                  user['status'],
                  style: GoogleFonts.spaceGrotesk(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 1,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, primary.withValues(alpha: 0.2), Colors.transparent],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildMiniStat(Icons.history, '${user['orders']} Orders', primary),
                  const SizedBox(width: 16),
                  _buildMiniStat(Icons.star, '${user['rating']}', primary),
                ],
              ),
              GestureDetector(
                onTap: () => setState(() => _selectedUserId = user['id']),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: primary.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    user['status'] == 'PENDING' ? 'Verify' : 'Manage',
                    style: GoogleFonts.spaceGrotesk(color: primary, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String label, Color primary) {
    return Row(
      children: [
        Icon(icon, color: primary.withValues(alpha: 0.6), size: 14),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(color: Colors.grey[400], fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildActionMenu(Color primary, Color pitchBlack) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      top: 0,
      child: GestureDetector(
        onTap: () => setState(() => _selectedUserId = null),
        child: Container(
          color: Colors.black54,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {}, // Prevent dismissal when tapping the menu
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF102216),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    border: Border.all(color: primary.withValues(alpha: 0.2)),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.8), blurRadius: 40)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'MANAGE USER: $_selectedUserId',
                              style: GoogleFonts.spaceGrotesk(
                                color: primary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                              onPressed: () => setState(() => _selectedUserId = null),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildActionItem(Icons.visibility_outlined, 'View Full Profile', primary),
                      _buildActionItem(Icons.receipt_long_outlined, 'Transaction History', primary),
                      _buildActionItem(Icons.verified_user_outlined, 'Verify Documents', primary),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                        child: Divider(color: Colors.white12),
                      ),
                      _buildActionItem(Icons.block, 'Suspend Account', Colors.redAccent),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String label, Color color) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
      leading: Icon(icon, color: color.withValues(alpha: 0.6), size: 22),
      title: Text(
        label,
        style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 15),
      ),
      onTap: () {},
    );
  }
}
