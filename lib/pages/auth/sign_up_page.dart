import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'otp_verification_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isPasswordVisible = false;
  bool _agreedToTerms = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const neonGreen = Color(0xFF25F46A);
    const inputBg = Color(0xFF1E1E1E); // Slightly Lighter than pure black for contrast

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Create Account',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Join SwiftServe to find professionals.',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 16,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 40),

                // Fields
                _buildLabel('Full Name'),
                _buildInput(
                  controller: _nameController,
                  icon: Icons.person_outline,
                  hint: 'John Doe',
                  inputBg: inputBg,
                  neonGreen: neonGreen,
                ),
                const SizedBox(height: 20),
                
                _buildLabel('Email Address'),
                _buildInput(
                  controller: _emailController,
                  icon: Icons.mail_outline,
                  hint: 'john@example.com',
                  inputBg: inputBg,
                  neonGreen: neonGreen,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                _buildLabel('Phone Number'),
                _buildInput(
                  controller: _phoneController,
                  icon: Icons.phone_outlined,
                  hint: '+1 (555) 000-0000',
                  inputBg: inputBg,
                  neonGreen: neonGreen,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),

                _buildLabel('Password'),
                _buildInput(
                  controller: _passwordController,
                  icon: Icons.lock_outline,
                  hint: '••••••••',
                  inputBg: inputBg,
                  neonGreen: neonGreen,
                  isPassword: true,
                ),

                const SizedBox(height: 24),

                // Checkbox
                Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _agreedToTerms,
                        activeColor: neonGreen,
                        checkColor: Colors.black,
                        side: BorderSide(color: Colors.grey[600]!, width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        onChanged: (value) {
                          setState(() {
                            _agreedToTerms = value ?? false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: 'I agree to the ',
                          style: GoogleFonts.spaceGrotesk(color: Colors.grey[400], fontSize: 13),
                          children: [
                            TextSpan(
                              text: 'Terms of Service',
                              style: GoogleFonts.spaceGrotesk(color: neonGreen, fontWeight: FontWeight.bold),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: GoogleFonts.spaceGrotesk(color: neonGreen, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() && _agreedToTerms) {
                         // Perform Sign Up Logic
                         Navigator.push(
                           context,
                           MaterialPageRoute(
                             builder: (context) => OTPVerificationPage(email: _emailController.text),
                           ),
                         );
                      } else if (!_agreedToTerms) {
                         ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text('Please agree to the Terms of Service.')),
                         );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: neonGreen,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Create Account',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                
                // Footer
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: GoogleFonts.spaceGrotesk(color: Colors.grey[500], fontSize: 14),
                        children: [
                          TextSpan(
                            text: 'Log In',
                            style: GoogleFonts.spaceGrotesk(
                              color: neonGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.spaceGrotesk(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    required Color inputBg,
    required Color neonGreen,
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: inputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? !_isPasswordVisible : false,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        validator: (value) {
            if (value == null || value.isEmpty) {
                return 'Please enter data';
            }
            return null;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey[500]),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey[500],
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
