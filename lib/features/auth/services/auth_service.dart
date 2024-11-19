//Task 5: Firebase Authentication
// connects to Firebase Authentication to register a new user with email and password
// and to log in an existing user with email and password.
// lib/features/auth/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import 'email_verification_service.dart';
import 'package:logger/logger.dart';

class AuthService {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
    ),
  );
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
    String role = 'user', // Default role parameter
  }) async {
    try {
      final (isValid, message) = await _emailVerificationService.verifyEmail(email);

      if (!isValid) {
        return (null, message);
      }

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    /// Register user with email and password
      if (userCredential.user != null) {
        final user = User(
          uid: userCredential.user!.uid,
          name: name,
          surname: surname,
          email: email,
          idNumber: idNumber,
          province: province,
          role: role, // Set the role
          createdAt: DateTime.now(),
        );

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

  // Add method to check if user is admin
  Future<bool> isUserAdmin() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      final docSnapshot = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!docSnapshot.exists) return false;

      final userData = User.fromMap(docSnapshot.data()!);
      return userData.role == 'admin';
    } catch (e) {
      return false;
    }
  }

  // Add method to update user role (admin only)
  Future<String> updateUserRole(String userId, String newRole) async {
    try {
      // Check if current user is admin
      if (!await isUserAdmin()) {
        return 'Only admins can update user roles';
      }

      await _firestore
          .collection('users')
          .doc(userId)
          .update({'role': newRole});

      return 'Role updated successfully';
    } catch (e) {
      return 'Failed to update role: $e';
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

  Future<bool> hasUserVoted(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('votes') // Collection name
          .where('userId', isEqualTo: userId) // Query for votes by the user
          .limit(1) // Limit to one result for efficiency
          .get();

      // Check if any documents exist for this user
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      // Log the error (or handle it as needed)
      _logger.d('Error checking if user has voted: $e');
      return false; // Default to false if an error occurs
    }
  }

  // Watch candidate vote counts
  Stream<Map<String, int>> watchCandidateVoteCounts() {
    return _firestore.collection('votes').snapshots().map((snapshot) {
      final counts = <String, int>{};
      for (var doc in snapshot.docs) {
        final candidateId = doc['candidateId'] as String;
        counts[candidateId] = (counts[candidateId] ?? 0) + 1;
      }
      return counts;
    });
  }

// Watch total votes
  Stream<int> watchTotalVotes() {
    return _firestore.collection('votes').snapshots().map((snapshot) {
      return snapshot.docs.length; // Total votes equal to the number of documents
    });
  }

// Watch province votes
  Stream<Map<String, Map<String, int>>> watchProvinceVotes() {
    return _firestore.collection('votes').snapshots().map((snapshot) {
      final provinceVotes = <String, Map<String, int>>{};
      for (var doc in snapshot.docs) {
        final province = doc['province'] as String;
        final candidateId = doc['candidateId'] as String;
        provinceVotes.putIfAbsent(province, () => {});
        provinceVotes[province]![candidateId] =
            (provinceVotes[province]?[candidateId] ?? 0) + 1;
      }
      return provinceVotes;
    });
    }
}