// lib/services/vote_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../home/models/candidate_model.dart';
import '../models/vote_model.dart';
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

  /// Stream of all candidates
  Stream<List<Candidate>> watchCandidates() {
    _logger.i('👀 Starting to watch candidates');
    return _firestore
        .collection('candidates')
        .snapshots()
        .map((snapshot) {
      _logger.i('📥 Received candidates snapshot: ${snapshot.docs.length} documents');
      return snapshot.docs
          .map((doc) => Candidate.fromMap(doc.data(), doc.id))
          .toList();
    })
        .handleError((error) {
      _logger.e('❌ Error watching candidates', error: error);
      return [];
    });
  }

  /// Function to check if a user has voted
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

  /// Function to cast a vote
  Future<String> castVote({
    required String userId,
    required String saId,
    required String candidateId,
  }) async {
    try {
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
/// Function to get the vote cast by a user
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

/// Stream of all votes
  Stream<Map<String, int>> watchCandidateVoteCounts() {
    _logger.i('👀 Starting to watch vote counts');
    return _firestore.collection('candidates')
        .snapshots()
        .map((snapshot) {
      _logger.i('📥 Received vote counts snapshot: ${snapshot.docs.length} documents');
      final voteCounts = <String, int>{};
      for (var doc in snapshot.docs) {
        voteCounts[doc.id] = doc.data()['voteCount'] ?? 0;
      }
      return voteCounts;
    })
        .handleError((error) {
      _logger.e('❌ Error watching vote counts', error: error);
      return {};
    });
  }

  Stream<int> watchTotalVotes() {
    _logger.i('👀 Starting to watch total votes');
    return _firestore.collection('votes')
        .snapshots()
        .map((snapshot) {
      _logger.i('📊 Total votes count: ${snapshot.docs.length}');
      return snapshot.docs.length;
    })
        .handleError((error) {
      _logger.e('❌ Error watching total votes', error: error);
      return 0;
    });
  }

  Stream<Map<String, Map<String, int>>> watchProvinceVotes() {
    _logger.i('👀 Starting to watch province votes');
    return _firestore.collection('votes')
        .snapshots()
        .map((snapshot) {
      _logger.i('📥 Received province votes snapshot: ${snapshot.docs.length} documents');
      final provinceVotes = <String, Map<String, int>>{};
      try {
        for (var doc in snapshot.docs) {
          final vote = Vote.fromMap(doc.data());
          provinceVotes.putIfAbsent(vote.province, () => {});
          provinceVotes[vote.province]![vote.candidateId] =
              (provinceVotes[vote.province]![vote.candidateId] ?? 0) + 1;
        }
      } catch (e) {
        _logger.e('Error processing province votes', error: e);
      }
      return provinceVotes;
    })
        .handleError((error) {
      _logger.e('❌ Error watching province votes', error: error);
      return {};
    });
  }
}