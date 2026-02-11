import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Step2Schedule extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrev;
  final Map<String, dynamic> data;

  const Step2Schedule({
    super.key,
    required this.onNext,
    required this.onPrev,
    required this.data,
  });

  @override
  State<Step2Schedule> createState() => _Step2ScheduleState();
}

class _Step2ScheduleState extends State<Step2Schedule> {
  late DateTime _focusedMonth;
  
  @override
  void initState() {
    super.initState();
    // Initialize focused month to selected date's month or current month
    DateTime initialDate = widget.data['date'] ?? DateTime.now();
    _focusedMonth = DateTime(initialDate.year, initialDate.month);
  }

  String get _selectedTime => widget.data['time'] ?? '10:30 AM';
  String get _selectedBudget => widget.data['budget'] ?? r'$50';

  void _setTime(String time) {
    setState(() {
      widget.data['time'] = time;
    });
  }

  void _setBudget(String budget) {
    setState(() {
      widget.data['budget'] = budget;
    });
  }

  void _setCustomBudget(String value) {
    setState(() {
      widget.data['budget'] = value.isEmpty ? null : '\$$value';
    });
  }

  DateTime get _selectedDate => widget.data['date'] ?? DateTime.now();

  void _setDate(DateTime date) {
    setState(() {
      widget.data['date'] = date;
    });
  }

  void _moveMonth(int offset) {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    const neonGreen = Color(0xFF25F46A);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Select Date
          _buildSectionTitle('SELECT DATE', neonGreen),
          const SizedBox(height: 12),
          _buildCalendar(neonGreen),

          const SizedBox(height: 32),

          // Select Time
          _buildSectionTitle('SELECT TIME', neonGreen),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTimeChip('09:00 AM', neonGreen),
                const SizedBox(width: 12),
                _buildTimeChip('10:30 AM', neonGreen),
                const SizedBox(width: 12),
                _buildTimeChip('01:00 PM', neonGreen),
                const SizedBox(width: 12),
                _buildTimeChip('03:30 PM', neonGreen),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Custom Time Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A0A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: neonGreen.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, color: Colors.grey[400], size: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    onChanged: (val) => _setTime(val),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter custom time (e.g. 11:15 AM)',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Select Budget
          _buildSectionTitle('SELECT YOUR BUDGET', neonGreen),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildBudgetChip('\$20', neonGreen),
              _buildBudgetChip('\$50', neonGreen),
              _buildBudgetChip('\$80', neonGreen),
              _buildBudgetChip('\$100', neonGreen),
              _buildBudgetChip('\$150+', neonGreen),
            ],
          ),
          const SizedBox(height: 12),
          // Custom Amount Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A0A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: neonGreen.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                Text('\$', style: TextStyle(color: Colors.grey[400], fontSize: 18)),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    onChanged: _setCustomBudget,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter custom amount',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Navigation Buttons
          Row(
            children: [
              // Prev
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 60,
                  child: OutlinedButton(
                    onPressed: widget.onPrev,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.white.withOpacity(0.1)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      backgroundColor: const Color(0xFF1A1A1A),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.arrow_back, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'PREV',
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Next
              Expanded(
                flex: 2,
                child: SizedBox(
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
                          'NEXT',
                          style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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

  Widget _buildCalendar(Color neonGreen) {
    // Simplified Static Calendar for UI Demo
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.grey),
                onPressed: () => _moveMonth(-1),
              ),
              Text(
                '${_getMonthName(_focusedMonth.month)} ${_focusedMonth.year}',
                style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.grey),
                onPressed: () => _moveMonth(1),
              ),
            ],
          ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['S','M','T','W','T','F','S'].map((day) => 
               SizedBox(width: 30, child: Center(child: Text(day, style: TextStyle(color: Colors.grey[600], fontSize: 12))))
            ).toList(),
          ),
          const SizedBox(height: 12),
          const SizedBox(height: 12),
          // Days Grid
          _buildDaysGrid(neonGreen),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const names = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return names[month - 1];
  }

  Widget _buildDaysGrid(Color neonGreen) {
    final daysInMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    final firstDayOffset = DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday % 7;
    
    List<Widget> rows = [];
    List<Widget> currentRow = [];

    // Add empty spaces for first week
    for (int i = 0; i < firstDayOffset; i++) {
      currentRow.add(const SizedBox(width: 36, height: 36));
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);
      final isSelected = _selectedDate.year == date.year && _selectedDate.month == date.month && _selectedDate.day == date.day;
      
      currentRow.add(_buildDay(day.toString(), isSelected, neonGreen, date));
      
      if (currentRow.length == 7) {
        rows.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: currentRow),
        ));
        currentRow = [];
      }
    }

    if (currentRow.isNotEmpty) {
      while (currentRow.length < 7) {
        currentRow.add(const SizedBox(width: 36, height: 36));
      }
      rows.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: currentRow),
      ));
    }

    return Column(children: rows);
  }

  Widget _buildDay(String day, bool isSelected, Color color, DateTime date) {
    return GestureDetector(
      onTap: () => _setDate(date),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? color : Colors.transparent,
          boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 8)] : [],
        ),
        child: Center(
          child: Text(
            day,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeChip(String time, Color activeColor) {
    final isSelected = time == _selectedTime;
    return GestureDetector(
      onTap: () => _setTime(time),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : const Color(0xFF0A0A0A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? activeColor : Colors.white.withOpacity(0.1)),
          boxShadow: isSelected ? [BoxShadow(color: activeColor.withOpacity(0.3), blurRadius: 10)] : [],
        ),
        child: Text(
          time,
          style: GoogleFonts.spaceGrotesk(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetChip(String amount, Color activeColor) {
    final isSelected = amount == _selectedBudget;
    return GestureDetector(
      onTap: () => _setBudget(amount),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.1) : const Color(0xFF0A0A0A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? activeColor : Colors.white.withOpacity(0.1)),
          boxShadow: isSelected ? [BoxShadow(color: activeColor.withOpacity(0.1), blurRadius: 8)] : [],
        ),
        child: Text(
          amount,
          style: GoogleFonts.spaceGrotesk(
            color: isSelected ? activeColor : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
