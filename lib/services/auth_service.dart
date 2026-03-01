import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io' show Platform;
import '../models/user.dart' as model;

class AuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream for auth state
  Stream<auth.User?> get userStream => _auth.authStateChanges();

  // Sign Up for Client
  Future<auth.UserCredential?> signUpClient({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      auth.UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user to Firestore
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'name': name,
        'email': email,
        'phone': phone,
        'role': 'client',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return credential;
    } catch (e) {
      rethrow;
    }
  }

  // Sign Up for Provider
  Future<auth.UserCredential?> signUpProvider({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String category,
    required String experience,
    required String price,
    required String bio,
    required String location,
  }) async {
    try {
      auth.UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save provider to Firestore
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'name': name,
        'email': email,
        'phone': phone,
        'role': 'provider',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Also save to providers collection
      await _firestore.collection('providers').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'name': name,
        'category': category,
        'experience': experience,
        'priceStart': double.tryParse(price) ?? 0.0,
        'bio': bio,
        'location': location,
        'rating': 5.0,
        'reviewsCount': 0,
        'isApproved': false, // Admin review
      });

      return credential;
    } catch (e) {
      rethrow;
    }
  }

  // Sign In
  Future<auth.UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  // Google Sign In
  Future<auth.UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      
      // If new user, create basic profile
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'name': userCredential.user!.displayName ?? 'New User',
          'email': userCredential.user!.email,
          'phone': userCredential.user!.phoneNumber ?? '',
          'role': 'client', // Default role
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Apple Sign In
  Future<auth.UserCredential?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final auth.AuthCredential credential = auth.OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      // If new user, create basic profile
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'name': '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'.trim().isEmpty 
              ? 'Apple User' 
              : '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'.trim(),
          'email': appleCredential.email,
          'phone': '',
          'role': 'client', // Default role
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Get current user role
  Future<String?> getUserRole(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return (doc.data() as Map<String, dynamic>)['role'];
    }
    return null;
  }
}
