import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/provider.dart';

class BookingPage extends StatefulWidget {
  final Provider provider;

  const BookingPage({super.key, required this.provider});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime _selectedDate = DateTime.now();
  String _selectedTime = '10:00 AM';

  final List<String> _times = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Book Service',
          style: GoogleFonts.spaceGrotesk(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Provider Info Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 255, 255, 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color.fromRGBO(255, 255, 255, 0.1)),
              ),
              child: Row(
                children: [
                   CircleAvatar(
                     radius: 24,
                     backgroundImage: NetworkImage(widget.provider.imageUrl),
                   ),
                   const SizedBox(width: 16),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         widget.provider.name,
                         style: GoogleFonts.spaceGrotesk(
                           color: Colors.white,
                           fontSize: 16,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                       Text(
                         widget.provider.role,
                         style: GoogleFonts.spaceGrotesk(
                           color: Colors.grey[400],
                           fontSize: 12,
                         ),
                       ),
                     ],
                   ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'SELECT DATE',
              style: GoogleFonts.spaceGrotesk(
                color: Colors.grey[500],
                fontSize: 12,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Simple mockup calendar or date picker
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 14,
                itemBuilder: (context, index) {
                  final date = DateTime.now().add(Duration(days: index));
                  final isSelected = date.day == _selectedDate.day;
                  
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDate = date),
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF25F46A) : const Color.fromRGBO(255, 255, 255, 0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: isSelected ? null : Border.all(color: const Color.fromRGBO(255, 255, 255, 0.1)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getMonth(date.month),
                            style: GoogleFonts.spaceGrotesk(
                              color: isSelected ? Colors.black : Colors.grey[500],
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            date.day.toString(),
                            style: GoogleFonts.spaceGrotesk(
                              color: isSelected ? Colors.black : Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'SELECT TIME',
              style: GoogleFonts.spaceGrotesk(
                color: Colors.grey[500],
                fontSize: 12,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _times.map((time) {
                final isSelected = time == _selectedTime;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTime = time),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF25F46A) : const Color.fromRGBO(255, 255, 255, 0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: isSelected ? null : Border.all(color: const Color.fromRGBO(255, 255, 255, 0.1)),
                    ),
                    child: Text(
                      time,
                      style: GoogleFonts.spaceGrotesk(
                        color: isSelected ? Colors.black : Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            // Confirm Button
             GestureDetector(
              onTap: () {
                // Here we would submit the booking
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Booking Request Sent!')),
                );
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Container(
                height: 64,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF25F46A),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF25F46A).withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  'Confirm Booking',
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
