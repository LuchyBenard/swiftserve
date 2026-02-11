import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/booking.dart';
import 'tracking/job_tracking_page.dart';
import 'rating/rate_provider_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool _showActive = true;

  final List<Booking> _allBookings = [
    Booking(
      id: '1',
      providerName: 'TechFix Mobile',
      serviceType: 'Phone Repair',
      status: 'In Progress',
      date: 'Today',
      time: '2:00 PM',
      location: '123 Market St, SF',
      price: 120.0,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCFQ7PW4mJq0pCsms1S5jz6jktvhtIvJQ9pCJONsOidljGYa7n-oOe3IfKlHfO8bAO2UdEGUQFcIaTidjxESclQcNwqAVjyIKdxjfQkF5l0qxfkG5_GnqCv55JJpxEb5piWICYx5fyA3b8zNi6xi5Sn8JYfwGGQEgmJW_hQWFG2K685urWWLtHgOjZkVBxQ9xxK4TOrOfOo619efYpLS_RSNTrKfwdGF9_rsCbFrv3wy1fv9nPbKlWmBLHpJsNhKJmqCGzElH2jR2uT',
    ),
    Booking(
      id: '2',
      providerName: 'John D.',
      serviceType: 'Haircut & Beard Trim',
      status: 'Confirmed',
      date: 'Tomorrow',
      time: '10:00 AM',
      location: 'Provider Shop',
      price: 45.0,
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAQY-wJQBD18t4GYQjf_DFHRKKTDMbwPTEdf3y0G3_pnsISu96W29vq7mSX_7ZURbByCaRcP_rwjXjYO-jZ39d-I7PFbj8H7q9lk0z6UDFMsHpTKJPX0LUYEk6HZQPzr9xvCAnMpI8GxGKxTjSZNMYqcmy1Eh5VNKh3loa7SWv2WqNT7MEFGNFATRVabclMw7Qq5uPMRZcpobPAT3CZrA8ovg5y72uAKbEJ2BZxTDmO-i1v2g7Aq-imn2ikZzb3sMuRdbeEL2aXU0qS',
    ),
    Booking(
      id: '3',
      providerName: 'Mike\'s Plumbing',
      serviceType: 'Leak Fix',
      status: 'Completed',
      date: 'Oct 24',
      time: '4:30 PM',
      location: '',
      price: 150.0,
      imageUrl: '', // Using icon placeholder logic
    ),
    Booking(
      id: '4',
      providerName: 'Sparkle Clean',
      serviceType: 'Home Cleaning',
      status: 'Canceled',
      date: 'Oct 12',
      time: '9:00 AM',
      location: '',
      price: 80.0,
      imageUrl: '', // Using icon placeholder logic
    ),
  ];

  List<Booking> get _filteredBookings {
    if (_showActive) {
      return _allBookings.where((b) => b.status == 'In Progress' || b.status == 'Confirmed').toList();
    } else {
      return _allBookings.where((b) => b.status == 'Completed' || b.status == 'Canceled').toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(
        children: [
          const SizedBox(height: 16),
          _buildHeader(),
          const SizedBox(height: 24),
          _buildToggle(),
          const SizedBox(height: 24),
          _buildBookingList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'History',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'YOUR BOOKINGS',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.grey[400],
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color.fromRGBO(37, 244, 106, 0.2), width: 2),
            ),
            child: const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuCqaZ7wk8boFIodQC_72x7gFRiF-KA6YLJuS5oG787ow5E6cLDav6l_BvN9b8MFowza2zKonigLZuY4910ShpjHQLW9A7Fj_7k6AMzI0JNMBa1EOrExgnZr_W-t9OZWd02hW3qIm5zf3KHs_Opa9s_8_0MeRGhiLbBxE2owIqQY84oOJOEsTnjK3hkyVvq9ZcrEhEgDCgilg-b8o7f2kH-IhMntmDQcIhOIU54NJFLtCj-XVoZVmtQoEdxEm2dI5zYAJ18MQ_JQ2d6b'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, 0.05),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.1)),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _showActive = true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: _showActive ? const Color(0xFF25F46A) : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: _showActive
                        ? [
                            BoxShadow(
                              color: const Color(0xFF25F46A).withOpacity(0.3),
                              blurRadius: 15,
                            )
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Active',
                    style: GoogleFonts.spaceGrotesk(
                      color: _showActive ? Colors.black : Colors.grey[400],
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _showActive = false),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: !_showActive ? const Color.fromRGBO(255, 255, 255, 0.05) : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Past',
                    style: GoogleFonts.spaceGrotesk(
                      color: !_showActive ? Colors.white : Colors.grey[400],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingList() {
    final bookings = _filteredBookings;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: bookings.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return _BookingCard(booking: bookings[index]);
        },
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Booking booking;

  const _BookingCard({required this.booking});

  Color _getStatusColor() {
    switch (booking.status) {
      case 'In Progress':
        return Colors.amber;
      case 'Confirmed':
        return Colors.blue;
      case 'Completed':
        return const Color(0xFF25F46A);
      case 'Canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final isCanceled = booking.status == 'Canceled';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF080808),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.05)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JobTrackingPage(
                  providerName: booking.providerName,
                  serviceType: booking.serviceType,
                  providerImageUrl: booking.imageUrl.isNotEmpty 
                      ? booking.imageUrl 
                      : 'https://lh3.googleusercontent.com/aida-public/AB6AXuC2rC0jTUAzlbWZb9L6KQ87L1pOOJM3JGf2QQ5U9yc3GxyHKieh_lzQ2QwbRBLHFq86YShsjQqioBqk1WO0mn0FsfGMzJtfc7mTd5BIiid_rfQ6Vm2lqFkSYCHvfNjP_sMRBLptPVdg2tSRJ5hLdf1zUzXLb4-2OaF5Q_KsGq58Dk73VnUqWPFbBTumHh8J7JevvFKPnrtDuP0m4NaEk-9ITeRB1wrx39AbwC-8vhcy0KoLxqdbU9pGWneDYeXOkcjBaRc5AYYmRmKa',
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(32),
          hoverColor: const Color(0xFF25F46A).withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildThumbnail(),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.providerName,
                              style: GoogleFonts.spaceGrotesk(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              booking.serviceType,
                              style: GoogleFonts.spaceGrotesk(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor.withOpacity(0.2)),
                      ),
                      child: Text(
                        booking.status.toUpperCase(),
                        style: GoogleFonts.spaceGrotesk(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(height: 1, color: const Color.fromRGBO(255, 255, 255, 0.05)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 16, color: Colors.grey[400]),
                            const SizedBox(width: 6),
                            Text(
                              '${booking.date}, ${booking.time}',
                              style: GoogleFonts.spaceGrotesk(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        if (booking.location.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 16, color: Colors.grey[400]),
                              const SizedBox(width: 6),
                              Text(
                                booking.location,
                                style: GoogleFonts.spaceGrotesk(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          isCanceled ? 'Refunded' : 'Total',
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.grey[500],
                            fontSize: 10,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          '\$${booking.price.toInt()}',
                          style: GoogleFonts.spaceGrotesk(
                            color: isCanceled ? Colors.white.withOpacity(0.5) : const Color(0xFF25F46A),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            decoration: isCanceled ? TextDecoration.lineThrough : null,
                            decorationColor: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (booking.status == 'Completed') ...[
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RateProviderPage(
                            providerName: booking.providerName,
                            providerRole: booking.serviceType,
                            providerImageUrl: booking.imageUrl.isNotEmpty 
                                ? booking.imageUrl 
                                : 'https://lh3.googleusercontent.com/aida-public/AB6AXuAQY-wJQBD18t4GYQjf_DFHRKKTDMbwPTEdf3y0G3_pnsISu96W29vq7mSX_7ZURbByCaRcP_rwjXjYO-jZ39d-I7PFbj8H7q9lk0z6UDFMsHpTKJPX0LUYEk6HZQPzr9xvCAnMpI8GxGKxTjSZNMYqcmy1Eh5VNKh3loa7SWv2WqNT7MEFGNFATRVabclMw7Qq5uPMRZcpobPAT3CZrA8ovg5y72uAKbEJ2BZxTDmO-i1v2g7Aq-imn2ikZzb3sMuRdbeEL2aXU0qS',
                            serviceDescription: 'Standard Service',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF25F46A).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF25F46A).withOpacity(0.3)),
                      ),
                      child: Center(
                        child: Text(
                          'Rate Service',
                          style: GoogleFonts.spaceGrotesk(
                            color: const Color(0xFF25F46A),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    if (booking.imageUrl.isNotEmpty) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(booking.imageUrl),
            fit: BoxFit.cover,
          ),
          border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.1)),
        ),
      );
    } else {
      // Placeholder based on service type
      IconData icon = Icons.work;
      if (booking.serviceType.contains('Plumbing')) icon = Icons.plumbing;
      if (booking.serviceType.contains('Cleaning')) icon = Icons.cleaning_services;

      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          shape: BoxShape.circle,
          border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.1)),
        ),
        child: Icon(icon, color: Colors.grey[400], size: 24),
      );
    }
  }
}
