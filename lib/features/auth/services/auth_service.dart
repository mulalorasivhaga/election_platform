//Task 5: Firebase Authentication
// connects to Firebase Authentication to register a new user with email and password
// and to log in an existing user with email and password.
// lib/features/auth/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import 'email_verification_service.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final EmailVerificationService _emailVerificationService = EmailVerificationService();

  // Add public method to verify email
  Future<(bool, String)> verifyEmail(String email) async {
    return await _emailVerificationService.verifyEmail(email);
  }

  Future<(User?, String)> registerUser({
    required String email,
    required String password,
    required String name,
    required String surname,
    required String idNumber,
    required String province,
  }) async {
    try {
      // First, verify the email
      final (isValid, message) = await _emailVerificationService.verifyEmail(email);

      if (!isValid) {
        return (null, message);
      }

      // Proceed with registration if email is valid
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Create User model
        final user = User(
          uid: userCredential.user!.uid,
          name: name,
          surname: surname,
          email: email,
          idNumber: idNumber,
          province: province,
          createdAt: DateTime.now(),
        );

        // Save user data to Firestore
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(user.toMap());

        return (user, 'Success');
      }
      return (null, 'Registration failed');
    } on firebase_auth.FirebaseAuthException catch (e) {
      return (null, _handleFirebaseAuthError(e));
    } catch (e) {
      return (null, 'An unexpected error occurred: $e');
    }
  }

  /// Log in user with email and password
  Future<(User?, String)> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      // Attempt to sign in
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Fetch user data from Firestore
        final docSnapshot = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (docSnapshot.exists) {
          // Convert Firestore data to User model
          final userData = User.fromMap(docSnapshot.data()!);
          return (userData, 'Success');
        } else {
          return (null, 'User data not found');
        }
      }
      return (null, 'Login failed');
    } on firebase_auth.FirebaseAuthException catch (e) {
      return (null, _handleFirebaseAuthError(e));
    } catch (e) {
      return (null, 'An unexpected error occurred: $e');
    }
  }


  /// Handle Firebase Auth errors
  String _handleFirebaseAuthError(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed login attempts. Please try again later.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      default:
        return 'Authentication error: ${e.message}';
    }
  }
}