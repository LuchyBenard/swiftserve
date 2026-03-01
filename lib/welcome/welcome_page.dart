import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/auth/forgot_password_page.dart';
import '../pages/auth/sign_up_page.dart';
import '../pages/auth/worker_registration_page.dart';
import '../pages/bottomnav.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isPasswordVisible = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const neonGreen = Color(0xFF25F46A);
    const inputBg = Color(0xFF121212);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Top Pulse Glow
          Positioned(
            top: -50,
            left: MediaQuery.of(context).size.width / 2 - 300,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 600,
                    height: 600,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: neonGreen.withOpacity(0.1),
                    ),
                    child: Container( // Simulated blur via gradient or just opacity
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                                BoxShadow(
                                    color: neonGreen.withOpacity(0.1),
                                    blurRadius: 120,
                                    spreadRadius: 20,
                                )
                            ]
                        ),
                    ),
                  ),
                );
              },
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     // Logo
                     Stack(
                       alignment: Alignment.center,
                       children: [
                         Container(
                           width: 120,
                           height: 120,
                           decoration: BoxDecoration(
                             color: neonGreen.withOpacity(0.3),
                             shape: BoxShape.circle,
                           ), // Blur handled by outer container or separate widget if needed perfectly
                           child: Center(
                               child: Container(
                                   width: 80, height: 80,
                                   decoration: BoxDecoration(shape: BoxShape.circle, color: neonGreen.withOpacity(0.2)),
                               )
                           ),
                         ),
                         Icon(
                           Icons.bolt,
                           size: 100,
                           color: neonGreen,
                           shadows: [
                             BoxShadow(
                               color: neonGreen.withOpacity(0.8),
                               blurRadius: 15,
                             )
                           ],
                         ),
                       ],
                     ),
                     
                     const SizedBox(height: 40),
                     
                     // Texts
                     Text(
                       'Welcome Back',
                       style: GoogleFonts.spaceGrotesk(
                         fontSize: 32,
                         fontWeight: FontWeight.bold,
                         color: Colors.white,
                       ),
                     ),
                     const SizedBox(height: 8),
                     Text(
                       'Sign in to continue using SwiftServe',
                       style: GoogleFonts.spaceGrotesk(
                         fontSize: 16,
                         fontWeight: FontWeight.w300,
                         color: Colors.grey[400],
                       ),
                     ),
                     
                     const SizedBox(height: 40),
                     
                     DefaultTabController(
                       length: 2,
                       child: Column(
                         children: [
                           TabBar(
                             indicatorColor: neonGreen,
                             labelColor: neonGreen,
                             unselectedLabelColor: Colors.grey[600],
                             labelStyle: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
                             tabs: const [
                               Tab(text: 'CLIENT'),
                               Tab(text: 'PROVIDER'),
                             ],
                           ),
                           const SizedBox(height: 30),
                           // Form
                           _buildInput(
                             controller: _emailController,
                             icon: Icons.mail_outline,
                             hint: 'Email address',
                             inputBg: inputBg,
                             neonGreen: neonGreen,
                           ),
                           const SizedBox(height: 20),
                           _buildInput(
                             controller: _passwordController,
                             icon: Icons.lock_outline,
                             hint: 'Password',
                             inputBg: inputBg,
                             neonGreen: neonGreen,
                             isPassword: true,
                           ),
                         ],
                       ),
                     ),
                     
                     const SizedBox(height: 10),
                     Align(
                       alignment: Alignment.centerRight,
                       child: TextButton(
                         onPressed: () {
                             Navigator.push(
                               context,
                               MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                             );
                           },
                         child: Text(
                           'Forgot Password?',
                           style: GoogleFonts.spaceGrotesk(
                             color: neonGreen,
                             fontSize: 14,
                             fontWeight: FontWeight.w500,
                           ),
                         ),
                       ),
                     ),
                     
                     const SizedBox(height: 20),
                     
                     // Login Button
                     SizedBox(
                       width: double.infinity,
                       height: 60,
                       child: ElevatedButton(
                         onPressed: () async {
                           if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please enter both email and password')),
                              );
                              return;
                           }

                           try {
                             showDialog(
                               context: context,
                               barrierDismissible: false,
                               builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFF25F46A))),
                             );

                             await AuthService().signIn(
                               _emailController.text.trim(),
                               _passwordController.text.trim(),
                             );

                             if (context.mounted) {
                               Navigator.pop(context); // Close loading dialog
                               // AuthGate will handle navigation automatically
                             }
                           } on FirebaseAuthException catch (e) {
                             if (context.mounted) {
                               Navigator.pop(context); // Close loading dialog
                               ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(content: Text(e.message ?? 'Login failed')),
                               );
                             }
                           } catch (e) {
                             if (context.mounted) {
                               Navigator.pop(context); // Close loading dialog
                               ScaffoldMessenger.of(context).showSnackBar(
                                 const SnackBar(content: Text('An unexpected error occurred')),
                               );
                             }
                           }
                         },
                         style: ElevatedButton.styleFrom(
                           backgroundColor: neonGreen,
                           foregroundColor: Colors.black,
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(16),
                           ),
                           elevation: 10,
                           shadowColor: neonGreen.withOpacity(0.4),
                         ),
                         child: Text(
                           'Login',
                           style: GoogleFonts.spaceGrotesk(
                             fontSize: 18,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                       ),
                     ),

                     const SizedBox(height: 40),

                     // Or divider
                     Row(
                       children: [
                         Expanded(child: Divider(color: Colors.grey[800])),
                         Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 16),
                           child: Text(
                             'Or continue with',
                             style: TextStyle(color: Colors.grey[500], fontSize: 13),
                           ),
                         ),
                         Expanded(child: Divider(color: Colors.grey[800])),
                       ],
                     ),

                     const SizedBox(height: 30),

                     // Social Buttons
                     Row(
                       children: [
                         Expanded(
                           child: _buildSocialButton(
                             Icons.g_mobiledata, 
                             Colors.blue,
                             onTap: () => _handleSocialLogin('Google'),
                           ),
                         ),
                         const SizedBox(width: 16),
                         Expanded(
                           child: _buildSocialButton(
                             Icons.apple, 
                             Colors.white,
                             onTap: () => _handleSocialLogin('Apple'),
                           ),
                         ),
                       ],
                     ),

                     const SizedBox(height: 40),

                     // Sign Up
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text(
                           "Don't have an account?",
                           style: TextStyle(color: Colors.grey[500], fontSize: 14),
                         ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SignUpPage()),
                              );
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          )
                       ],
                     ),
                     const SizedBox(height: 12),
                     
                     // Provider Link
                     TextButton(
                       onPressed: () {
                         Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => const WorkerRegistrationPage()),
                         );
                       },
                       child: Text(
                         'BECOME A SERVICE PROVIDER',
                         style: GoogleFonts.spaceGrotesk(
                           color: neonGreen,
                           fontSize: 12,
                           fontWeight: FontWeight.bold,
                           letterSpacing: 1.2,
                         ),
                       ),
                     ),
                  ],
                ),
              ),
            ),
          )
        ],
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
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
             color: Colors.black,
             offset: Offset(0, 2),
             blurRadius: 2,
          ) // Inner shadow simulation usually needs library or complex render, skipping for simple flat style
        ]
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? !_isPasswordVisible : false,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey[600]),
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: neonGreen),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
        ),
      ),
    );
  }

  Future<void> _handleSocialLogin(String provider) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFF25F46A))),
      );

      UserCredential? credential;
      if (provider == 'Google') {
        credential = await AuthService().signInWithGoogle();
      } else {
        credential = await AuthService().signInWithApple();
      }

      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        if (credential == null) {
          // User cancelled
          return;
        }
        // AuthGate will handle navigation automatically
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login with $provider failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildSocialButton(IconData icon, Color color, {required VoidCallback onTap}) {
    return Container(
      height: 56,
      decoration: BoxDecoration( // for group-hover logic, standard InkWell is fine
        border: Border.all(color: Colors.grey[800]!),
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Center(
          child: Icon(icon, color: color, size: 30),
        ),
      ),
    );
  }
}