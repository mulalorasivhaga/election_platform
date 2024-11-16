// lib/features/auth/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<(User?, String)> registerUser({
    required String email,
    required String password,
    required String name,
    required String surname,
    required String idNumber,
    required String province,
  }) async {
    try {
      // Create authentication user
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

  String _handleFirebaseAuthError(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      default:
        return 'Authentication error: ${e.message}';
    }
  }
}