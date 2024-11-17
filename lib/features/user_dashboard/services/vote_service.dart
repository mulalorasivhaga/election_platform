// lib/services/vote_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/vote_model.dart';
import 'package:logger/logger.dart';

class VoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final Logger _logger = Logger();

  // Check if SA ID has already voted
  Future<bool> hasSAIdVoted(String saId) async {
    try {
      final querySnapshot = await _firestore
          .collection('votes')
          .where('saId', isEqualTo: saId)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      _logger.e('Error checking if SA ID voted: $e');
      rethrow;
    }
  }

  // Check if user has already voted
  Future<bool> hasUserVoted(String userId) async {
    try {
      final voteDoc = await _firestore
          .collection('votes')
          .doc(userId)
          .get();

      return voteDoc.exists;
    } catch (e) {
      _logger.e('Error checking if user voted: $e');
      rethrow;
    }
  }

  // Cast a vote
  Future<String> castVote({
    required String saId,
    required String candidateId,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        _logger.e('No authenticated user found');
        return 'User not authenticated';
      }

      // Check if SA ID has already voted
      if (await hasSAIdVoted(saId)) {
        _logger.w('SA ID has already voted: $saId');
        return 'This ID number has already been used to vote';
      }

      // Check if user has already voted
      if (await hasUserVoted(user.uid)) {
        _logger.w('User has already voted: ${user.uid}');
        return 'You have already cast your vote';
      }

      // Verify that SA ID exists in users collection
      final userDoc = await _firestore
          .collection('users')
          .where('idNumber', isEqualTo: saId)
          .get();

      if (userDoc.docs.isEmpty) {
        _logger.w('SA ID not found in users collection: $saId');
        return 'Invalid ID number';
      }

      // Create vote
      final vote = Vote(
        userId: user.uid,
        saId: saId,
        candidateId: candidateId,
        timestamp: DateTime.now(),
      );

      // Save vote using user's UID as document ID
      await _firestore
          .collection('votes')
          .doc(user.uid)
          .set(vote.toMap());

      _logger.i('Vote cast successfully for SA ID: $saId');
      return 'Vote cast successfully';
    } catch (e) {
      _logger.e('Error casting vote: $e');
      return 'Error casting vote: $e';
    }
  }

  // Get user's vote
  Future<Vote?> getUserVote() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final voteDoc = await _firestore
          .collection('votes')
          .doc(user.uid)
          .get();

      if (!voteDoc.exists) return null;

      return Vote.fromMap(voteDoc.data()!);
    } catch (e) {
      _logger.e('Error getting user vote: $e');
      return null;
    }
  }

  // Get vote by SA ID
  Future<Vote?> getVoteBySAId(String saId) async {
    try {
      final querySnapshot = await _firestore
          .collection('votes')
          .where('saId', isEqualTo: saId)
          .get();

      if (querySnapshot.docs.isEmpty) return null;

      return Vote.fromMap(querySnapshot.docs.first.data());
    } catch (e) {
      _logger.e('Error getting vote by SA ID: $e');
      return null;
    }
  }
}