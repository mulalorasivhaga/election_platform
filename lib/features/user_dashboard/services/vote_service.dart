// lib/services/vote_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../models/vote_model.dart';
import '../utils/id_validator.dart';
import '../utils/vote_exception.dart';
import 'package:logger/logger.dart';

class VoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
    ),
  );

  Future<bool> hasUserVoted(String userId) async {
    try {
      if (userId.isEmpty) {
        _logger.w('hasUserVoted called with empty userId');
        return false;
      }

      final voteDoc = await _firestore.collection('votes').doc(userId).get();
      return voteDoc.exists;
    } catch (e) {
      _logger.e('Error checking vote status: $e');
      return false;
    }
  }

  Future<String> castVote({
    required String userId,
    required String saId,
    required String candidateId,
  }) async {
    try {
      if (!IdValidator.isValidSouthAfricanId(saId)) {
        throw const VoteException('Invalid ID number format');
      }

      if (userId.isEmpty || candidateId.isEmpty) {
        throw const VoteException('Missing required fields');
      }

      final hasVoted = await hasUserVoted(userId);
      if (hasVoted) {
        throw const VoteException('Double voting detected');
      }

      return await _firestore.runTransaction((transaction) async {
        final voteRef = _firestore.collection('votes').doc(userId);
        final candidateRef = _firestore.collection('candidates').doc(candidateId);

        final voteDoc = await transaction.get(voteRef);
        if (voteDoc.exists) {
          throw const VoteException('Vote already cast');
        }

        final candidateDoc = await transaction.get(candidateRef);
        if (!candidateDoc.exists) {
          throw const VoteException('Invalid candidate selection');
        }

        transaction.set(voteRef, {
          'userId': userId,
          'candidateId': candidateId,
          'timestamp': FieldValue.serverTimestamp(),
        });

        transaction.update(candidateRef, {
          'voteCount': FieldValue.increment(1)
        });

        return 'Vote recorded successfully';
      });
    } on VoteException catch (e) {
      _logger.w('Vote validation failed: ${e.message}');
      return e.message;
    } catch (e) {
      _logger.e('Voting error occurred', error: e);
      return 'An error occurred while processing your vote';
    }
  }

  Future<Vote?> getUserVote() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final voteDoc = await _firestore.collection('votes').doc(user.uid).get();
      if (!voteDoc.exists) return null;

      return Vote.fromMap(voteDoc.data()!);
    } catch (e) {
      _logger.e('Error getting user vote: $e');
      return null;
    }
  }
}