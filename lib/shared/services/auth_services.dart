import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:election_platform/features/auth/models/user_model.dart' as auth;

class AuthService {
  final FirebaseFirestore _firestore;
  final firebase_auth.FirebaseAuth _auth;

// AuthService class constructor
  AuthService({
    required FirebaseFirestore firestore,
    required firebase_auth.FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  // Login user method
  Future<(auth.User?, String)> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final docSnapshot = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (docSnapshot.exists) {
          return (auth.User.fromMap(docSnapshot.data()!), 'Success');
        }
      }
      return (null, 'Login failed');
    } catch (e) {
      return (null, e.toString());
    }
  }

  // Register user method
  Future<(auth.User?, String)> registerUser({
    required String email,
    required String password,
    required String name,
    required String surname,
    required String idNumber,
    required String province,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final user = auth.User(
          uid: userCredential.user!.uid,
          name: name,
          surname: surname,
          email: email,
          idNumber: idNumber,
          province: province,
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(user.toMap());

        return (user, 'Success');
      }
      return (null, 'Registration failed');
    } catch (e) {
      return (null, e.toString());
    }
  }

  // watchTotalVotes method
  Stream<int> watchTotalVotes() {
    return _firestore
        .collection('election_stats')
        .doc('current')
        .snapshots()
        .map((doc) => doc.data()?['totalVoters'] ?? 0);
  }

  // getCurrentUser method
  Future<auth.User?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          return auth.User.fromMap(doc.data()!);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

