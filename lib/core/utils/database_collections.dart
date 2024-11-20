import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreInitializer {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<String> provinces = [
    'Western Cape',
    'Eastern Cape',
    'Northern Cape',
    'North West',
    'Free State',
    'Gauteng',
    'Limpopo',
    'Mpumalanga',
    'KwaZulu-Natal'
  ];

  Future<void> initializeCollections() async {
    try {
      await _initializeElectionStats();
      await _initializeProvincialStats();
      await _initializeProvincialVotes();
      await _initializeUserCollection();
      debugPrint('All collections initialized successfully!');
    } catch (e) {
      debugPrint('Error initializing collections: $e');
    }
  }

  // Initialize election stats collection
  Future<void> _initializeElectionStats() async {
    try {
      Map<String, Map<String, dynamic>> provinceStats = {};
      for (String province in provinces) {
        provinceStats[province] = {
          'registered': 0,
          'voted': 0,
          'turnout': 0.0
        };
      }

      await _firestore.collection('election_stats').doc('current').set({
        'totalVoters': 100,
        'votedCount': 0,
        'turnoutPercentage': 0.0,
        'provinceStats': provinceStats,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      debugPrint('Election stats initialized!');
    } catch (e) {
      debugPrint('Error initializing election stats: $e');
      rethrow;
    }
  }

  // Initialize users collection with initial admin user
  Future<void> _initializeUserCollection() async {
    try {
      // Create users collection with initial admin user
      await _firestore.collection('users').doc('admin').set({
        'uid': 'admin',
        'name': 'Admin',
        'surname': 'User',
        'email': 'admin@election.com',
        'idNumber': '0000000000000',
        'province': 'Gauteng',
        'role': 'admin',
        'createdAt': FieldValue.serverTimestamp(),
        'hasVoted': false,
      });

      // Create user roles collection
      await _firestore.collection('user_roles').doc('roles').set({
        'admin': ['full_access', 'manage_users', 'view_stats'],
        'user': ['vote', 'view_results'],
      });

      debugPrint('User collections initialized!');
    } catch (e) {
      debugPrint('Error initializing user collections: $e');
      rethrow;
    }
  }

  // Initialize provincial stats and votes collections
  Future<void> _initializeProvincialStats() async {
    try {
      final batch = _firestore.batch();

      for (String province in provinces) {
        final docRef = _firestore.collection('provincial_election_stats').doc(province);
        batch.set(docRef, {
          'lastUpdated': FieldValue.serverTimestamp(),
          'totalCount': 0,
          'totalVotes': 0
        });
      }

      await batch.commit();
      debugPrint('Provincial stats initialized!');
    } catch (e) {
      debugPrint('Error initializing provincial stats: $e');
      rethrow;
    }
  }

  // Initialize provincial votes collection
  Future<void> _initializeProvincialVotes() async {
    try {
      final batch = _firestore.batch();

      for (String province in provinces) {
        final docRef = _firestore.collection('provincial_votes').doc(province);
        batch.set(docRef, {
          'candidateVotes': {},
          'totalVotes': 0,
          'lastUpdated': FieldValue.serverTimestamp()
        });
      }

      await batch.commit();
      debugPrint('Provincial votes initialized!');
    } catch (e) {
      debugPrint('Error initializing provincial votes: $e');
      rethrow;
    }
  }

  // Helper functions for adding/updating records
  Future<void> addUser({
    required String userId,
    required String name,
    required String surname,
    required String email,
    required String idNumber,
    required String province,
    String role = 'user',
    bool hasVoted = false,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'uid': userId,
        'name': name,
        'surname': surname,
        'email': email,
        'idNumber': idNumber,
        'province': province,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
        'hasVoted': hasVoted,
      });
      debugPrint('User added successfully!');
    } catch (e) {
      debugPrint('Error adding user: $e');
      rethrow;
    }
  }

  /// Add a vote record to the votes collection
  Future<void> addVote({
    required String userId,
    required String candidateId,
    required String province,
  }) async {
    try {
      await _firestore.collection('votes').doc(userId).set({
        'userId': userId,
        'candidateId': candidateId,
        'province': province,
        'timestamp': FieldValue.serverTimestamp(),
      });
      debugPrint('Vote added successfully!');
    } catch (e) {
      debugPrint('Error adding vote: $e');
      rethrow;
    }
  }
}
