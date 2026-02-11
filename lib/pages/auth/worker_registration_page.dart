import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkerRegistrationPage extends StatefulWidget {
  const WorkerRegistrationPage({super.key});

  @override
  State<WorkerRegistrationPage> createState() => _WorkerRegistrationPageState();
}

class _WorkerRegistrationPageState extends State<WorkerRegistrationPage> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  
  // Form Controllers
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  
  String? _selectedCategory;
  String? _selectedLocation;
  
  final List<String> _categories = [
    'Phone Tech', 'Barber', 'Stylist', 'Plumber', 'Cleaner', 'Electrician', 'Carpenter'
  ];
  
  final List<String> _enuguLocations = [
    'Independence Layout', 'Achara Layout', 'Trans Ekulu', 'Abakpa', 'Coal Camp',
    'Emene', 'New Haven', 'Thinkers Corner', 'GRA', 'Ogui New Layout',
    'Awkunanaw', 'Gariki', 'Uwani', 'Obiagu', 'Maryland', 'Meniru',
    'Agbani Road', 'Eke-Obinagu', 'Iva Valley', 'Tinker', 'Garki', 'Topland',
    'Amechi'
  ];

  @override
  void dispose() {
    _experienceController.dispose();
    _priceController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _submitRegistration();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _submitRegistration() {
    if (_formKey.currentState!.validate()) {
      // Logic would go here to save the data
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF101010),
          title: Text('Success!', style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Text('Your provider application has been submitted successfully.', style: GoogleFonts.spaceGrotesk(color: Colors.grey[400])),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back from registration
              },
              child: const Text('GREAT', style: TextStyle(color: Color(0xFF25F46A))),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const neonGreen = Color(0xFF25F46A);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('BECOME A PROVIDER', style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.black,
          colorScheme: const ColorScheme.light(primary: neonGreen, onPrimary: Colors.black, secondary: neonGreen),
        ),
        child: Stepper(
          type: StepperType.horizontal,
          currentStep: _currentStep,
          onStepContinue: _nextStep,
          onStepCancel: _previousStep,
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: details.onStepContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: neonGreen,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(_currentStep == 2 ? 'SUBMIT' : 'CONTINUE', style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  if (_currentStep > 0) ...[
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: details.onStepCancel,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey[800]!),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('BACK', style: GoogleFonts.spaceGrotesk(color: Colors.white)),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
          steps: [
            Step(
              title: const Text(''),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              content: Form(
                key: _currentStep == 0 ? _formKey : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStepTitle('Professional Info'),
                    _buildLabel('Select Category'),
                    _buildDropdown(_categories, _selectedCategory, (val) => setState(() => _selectedCategory = val)),
                    const SizedBox(height: 20),
                    _buildLabel('Experience (Years)'),
                    _buildTextField(_experienceController, 'e.g. 5', TextInputType.number),
                  ],
                ),
              ),
            ),
            Step(
              title: const Text(''),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStepTitle('Pricing & Bio'),
                  _buildLabel('Starting Price (\$)'),
                  _buildTextField(_priceController, 'e.g. 40', TextInputType.number),
                  const SizedBox(height: 20),
                  _buildLabel('Tell us about your services'),
                  _buildTextField(_bioController, 'Describe what you do best...', TextInputType.multiline, maxLines: 4),
                ],
              ),
            ),
            Step(
              title: const Text(''),
              isActive: _currentStep >= 2,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStepTitle('Location'),
                  _buildLabel('Where in Enugu are you located?'),
                  _buildDropdown(_enuguLocations, _selectedLocation, (val) => setState(() => _selectedLocation = val)),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: neonGreen.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: neonGreen.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: neonGreen, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Your profile will be reviewed by our team before becoming public.',
                            style: GoogleFonts.spaceGrotesk(color: neonGreen, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Text(text, style: GoogleFonts.spaceGrotesk(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: GoogleFonts.spaceGrotesk(color: Colors.grey[400], fontSize: 14)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, TextInputType type, {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF101010),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[900]!),
      ),
      child: TextField(
        controller: controller,
        keyboardType: type,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[700]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String? value, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF101010),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[900]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text('Select...', style: TextStyle(color: Colors.grey[700])),
          dropdownColor: const Color(0xFF101010),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          items: items.map((String item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
