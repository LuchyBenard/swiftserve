import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/homepage.dart'; 
import '../pages/bottomnav.dart';
import '../widgets/provider_bottom_nav.dart';
import '../services/auth_service.dart';
import '../welcome/welcome_page.dart';
import '../onboarding/onboarding_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Auth State Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF25F46A)),
            ),
          );
        }

        // User is logged in
        if (snapshot.hasData) {
          final user = snapshot.data!;
          return FutureBuilder<String?>(
            future: AuthService().getUserRole(user.uid),
            builder: (context, roleSnapshot) {
              if (roleSnapshot.connectionState == ConnectionState.waiting) {
                 return const Scaffold(
                  backgroundColor: Colors.black,
                  body: Center(
                    child: CircularProgressIndicator(color: Color(0xFF25F46A)),
                  ),
                );
              }

              if (roleSnapshot.hasData) {
                final role = roleSnapshot.data;
                if (role == 'provider') {
                  return const ProviderBottomNav();
                } else {
                  return const BottomNavPage();
                }
              }
              
              return const BottomNavPage(); 
            },
          );
        }

        // User is NOT logged in - Check Onboarding
        return FutureBuilder<bool>(
          future: _checkOnboardingStatus(),
          builder: (context, onboardingSnapshot) {
            if (onboardingSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                backgroundColor: Colors.black,
                body: Center(
                  child: CircularProgressIndicator(color: Color(0xFF25F46A)),
                ),
              );
            }

            final bool onboardingCompleted = onboardingSnapshot.data ?? false;
            
            if (onboardingCompleted) {
              return const WelcomePage();
            } else {
              return const OnboardingPage();
            }
          },
        );
      },
    );
  }

  Future<bool> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_completed') ?? false;
  }
}
