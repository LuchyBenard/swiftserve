import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/booking.dart';
import '../services/booking_service.dart';
import '../widgets/cancel_booking_dialog.dart';
import 'tracking/job_tracking_page.dart';
import 'rating/rate_provider_page.dart';

const Color _kGreen = Color(0xFF25F46A);

const String _kFallbackProviderImage =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAQY-wJQBD18t4GYQjf_DFHRKKTDMbwPTEdf3y0G3_pnsISu96W29vq7mSX_7ZURbByCaRcP_rwjXjYO-jZ39d-I7PFbj8H7q9lk0z6UDFMsHpTKJPX0LUYEk6HZQPzr9xvCAnMpI8GxGKxTjSZNMYqcmy1Eh5VNKh3loa7SWv2WqNT7MEFGNFATRVabclMw7Qq5uPMRZcpobPAT3CZrA8ovg5y72uAKbEJ2BZxTDmO-i1v2g7Aq-imn2ikZzb3sMuRdbeEL2aXU0qS';

const String _kUserAvatar =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCqaZ7wk8boFIodQC_72x7gFRiF-KA6YLJuS5oG787ow5E6cLDav6l_BvN9b8MFowza2zKonigLZuY4910ShpjHQLW9A7Fj_7k6AMzI0JNMBa1EOrExgnZr_W-t9OZWd02hW3qIm5zf3KHs_Opa9s_8_0MeRGhiLbBxE2owIqQY84oOJOEsTnjK3hkyVvq9ZcrEhEgDCgilg-b8o7f2kH-IhMntmDQcIhOIU54NJFLtCj-XVoZVmtQoEdxEm2dI5zYAJ18MQ_JQ2d6b';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool _showActive = true;

  final BookingService _bookingService = BookingService();

  @override
  void initState() {
    super.initState();
    _bookingService.bookingsNotifier.addListener(_onBookingsChanged);
    _bookingService.listenToClientBookings();
  }

  @override
  void dispose() {
    _bookingService.bookingsNotifier.removeListener(_onBookingsChanged);
    super.dispose();
  }

  void _onBookingsChanged() {
    if (mounted) setState(() {});
  }

  List<Booking> get _allBookings => _bookingService.currentBookings;

  List<Booking> get _filteredBookings {
    if (_showActive) {
      return _allBookings
          .where((b) => b.status == 'In Progress' || b.status == 'Confirmed')
          .toList();
    }
    return _allBookings
        .where((b) => b.status == 'Completed' || b.status == 'Canceled')
        .toList();
  }

  void _cancelBooking(Booking booking, String reason) {
    _bookingService.cancelBooking(booking.id, reason: reason);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking canceled: $reason'),
        backgroundColor: const Color(0xFFFF5252),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
              border: Border.all(
                color: _kGreen.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(_kUserAvatar),
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
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _showActive = true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: _showActive ? _kGreen : Colors.transparent,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: _showActive
                        ? [
                            BoxShadow(
                              color: _kGreen.withValues(alpha: 0.3),
                              blurRadius: 15,
                            ),
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
                    color: !_showActive
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.transparent,
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
          final booking = bookings[index];
          return _BookingCard(
            booking: booking,
            onCancelled: (reason) => _cancelBooking(booking, reason),
          );
        },
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Booking booking;
  final ValueChanged<String> onCancelled;

  const _BookingCard({required this.booking, required this.onCancelled});

  String get _providerImage =>
      booking.imageUrl.isNotEmpty ? booking.imageUrl : _kFallbackProviderImage;

  Color _getStatusColor() {
    switch (booking.status) {
      case 'In Progress':
        return Colors.amber;
      case 'Confirmed':
        return Colors.blue;
      case 'Completed':
        return _kGreen;
      case 'Canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _openTracking(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobTrackingPage(
          providerName: booking.providerName,
          serviceType: booking.serviceType,
          providerImageUrl: _providerImage,
        ),
      ),
    );
  }

  void _openRating(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RateProviderPage(
          providerName: booking.providerName,
          providerRole: booking.serviceType,
          providerImageUrl: _providerImage,
          serviceDescription: 'Standard Service',
        ),
      ),
    );
  }

  Future<void> _handleCancel(BuildContext context) async {
    final reason = await CancelBookingDialog.show(
      context: context,
      providerName: booking.providerName,
      serviceType: booking.serviceType,
    );
    if (reason != null && context.mounted) {
      onCancelled(reason);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final isCanceled = booking.status == 'Canceled';
    final isActive =
        booking.status == 'In Progress' || booking.status == 'Confirmed';
    final isCompleted = booking.status == 'Completed';

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF080808),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openTracking(context),
          borderRadius: BorderRadius.circular(32),
          hoverColor: _kGreen.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Header: provider info + status chip
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.2),
                        ),
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
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
                const SizedBox(height: 16),

                // Details: date/location + price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.grey[400],
                            ),
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
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.grey[400],
                              ),
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
                            color: isCanceled
                                ? Colors.white.withValues(alpha: 0.5)
                                : _kGreen,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            decoration: isCanceled
                                ? TextDecoration.lineThrough
                                : null,
                            decorationColor: Colors.white.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Actions for active bookings
                if (isActive) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _openTracking(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _kGreen.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _kGreen.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Track Job',
                                style: GoogleFonts.spaceGrotesk(
                                  color: _kGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => _handleCancel(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.red.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.spaceGrotesk(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                // Action for completed bookings
                if (isCompleted) ...[
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => _openRating(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _kGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _kGreen.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Rate Service',
                          style: GoogleFonts.spaceGrotesk(
                            color: _kGreen,
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
    final border = Border.all(color: Colors.white.withValues(alpha: 0.1));

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
          border: border,
        ),
      );
    }

    // Placeholder icon based on provider name / service type
    final text = '${booking.providerName} ${booking.serviceType}';
    IconData icon = Icons.work;
    if (text.contains('Plumbing')) icon = Icons.plumbing;
    if (text.contains('Clean')) icon = Icons.cleaning_services;

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        shape: BoxShape.circle,
        border: border,
      ),
      child: Icon(icon, color: Colors.grey[400], size: 24),
    );
  }
}
