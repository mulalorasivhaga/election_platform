import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/home/models/candidate_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import '../../features/user_dashboard/utils/vote_exception.dart';

class VoteService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final Logger _logger = Logger();

  VoteService({
    required FirebaseFirestore firestore,
    FirebaseAuth? auth,
  }) : _firestore = firestore,
        _auth = auth ?? FirebaseAuth.instance;

  Stream<List<Candidate>> watchCandidates() {
    return _firestore
        .collection('candidates')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Candidate.fromMap(doc.data(), doc.id))
        .toList());
  }

  Stream<Map<String, int>> watchCandidateVoteCounts() {
    return _firestore.collection('votes').snapshots().map((snapshot) {
      final counts = <String, int>{};
      for (var doc in snapshot.docs) {
        final candidateId = doc.data()['candidateId'] as String;
        counts[candidateId] = (counts[candidateId] ?? 0) + 1;
      }
      return counts;
    });
  }

  Stream<int> watchTotalVotes() {
    return _firestore
        .collection('votes')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Future<bool> hasUserVoted(String userId) async {
    try {
      final doc = await _firestore.collection('votes').doc(userId).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  Future<void> castVote({
    required String userId,
    required String candidateId,
    required String province,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw const VoteException('User not authenticated');
      }

      // Verify user ID matches
      if (currentUser.uid != userId) {
        throw const VoteException('Invalid user ID');
      }

      // Check if collections exist first
      final statsDoc = await _firestore.collection('election_stats').doc('current').get();
      if (!statsDoc.exists) {
        _logger.e('Election stats document does not exist');
        throw const VoteException('Election configuration error');
      }

      await _firestore.runTransaction((transaction) async {
        // Check for existing vote
        final userVoteRef = _firestore.collection('votes').doc(userId);
        final userVoteDoc = await transaction.get(userVoteRef);

        if (userVoteDoc.exists) {
          throw const VoteException('User has already voted');
        }

        // Verify candidate exists
        final candidateRef = _firestore.collection('candidates').doc(candidateId);
        final candidateDoc = await transaction.get(candidateRef);
        if (!candidateDoc.exists) {
          throw const VoteException('Invalid candidate selection');
        }

        // Create vote document
        transaction.set(userVoteRef, {
          'userId': userId,
          'candidateId': candidateId,
          'province': province,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Update election stats
        transaction.update(_firestore.collection('election_stats').doc('current'), {
          'votedCount': FieldValue.increment(1),
          'provinceStats.$province.voted': FieldValue.increment(1),
          'lastUpdated': FieldValue.serverTimestamp(),
        });

        // Update provincial stats
        final provinceRef = _firestore.collection('provincial_election_stats').doc(province);
        transaction.update(provinceRef, {
          'totalVotes': FieldValue.increment(1),
          'lastUpdated': FieldValue.serverTimestamp(),
        });

        // Update provincial votes
        final provincialVoteRef = _firestore.collection('provincial_votes').doc(province);
        transaction.update(provincialVoteRef, {
          'candidateVotes.$candidateId': FieldValue.increment(1),
          'totalVotes': FieldValue.increment(1),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      });

      _logger.i('Vote successfully cast for user: $userId');
    } on VoteException {
      rethrow;
    } catch (e) {
      _logger.e('Error casting vote', error: e);
      throw VoteException('Failed to cast vote: ${e.toString()}');
    }
  }
}