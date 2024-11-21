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

  Stream<Map<String, Map<String, int>>> watchProvincialVoteCounts() {
    return _firestore.collection('provincial_votes').snapshots().map((snapshot) {
      final provincialCounts = <String, Map<String, int>>{};
      for (var doc in snapshot.docs) {
        final province = doc.id;
        final candidateVotes = doc.data()['candidateVotes'] as Map<String, dynamic>;
        provincialCounts[province] = candidateVotes.map(
              (key, value) => MapEntry(key, (value as num).toInt()),
        );
      }
      return provincialCounts;
    });
  }

  Stream<Map<String, int>> watchNationalVoteCounts() {
    return _firestore.collection('votes').snapshots().map((snapshot) {
      final counts = <String, int>{};
      for (var doc in snapshot.docs) {
        final candidateId = doc.data()['candidateId'] as String;
        counts[candidateId] = (counts[candidateId] ?? 0) + 1;
      }
      return counts;
    });
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
    required String nationalCandidateId,
    required String provincialCandidateId,
    required String province,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw const VoteException('User not authenticated');
      }

      await _firestore.runTransaction((transaction) async {
        // Check for existing vote
        final userVoteRef = _firestore.collection('votes').doc(userId);
        final userVoteDoc = await transaction.get(userVoteRef);

        if (userVoteDoc.exists) {
          throw const VoteException('User has already voted');
        }

        // Create vote document with both national and provincial votes
        transaction.set(userVoteRef, {
          'userId': userId,
          'nationalCandidateId': nationalCandidateId,
          'provincialCandidateId': provincialCandidateId,
          'province': province,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Update election stats
        transaction.update(_firestore.collection('election_stats').doc('current'), {
          'votedCount': FieldValue.increment(1),
          'lastUpdated': FieldValue.serverTimestamp(),
        });

        // Mark user as voted
        transaction.update(_firestore.collection('users').doc(userId), {
          'hasVoted': true,
        });
      });

      _logger.i('Vote successfully cast for user: $userId');
    } catch (e) {
      _logger.e('Error casting vote', error: e);
      rethrow;
    }
  }

  Stream<Map<String, double>> getProvincialVotePercentages(String province) {
    return _firestore
        .collection('provincial_votes')
        .doc(province)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return {};

      final data = doc.data()!;
      final candidateVotes = data['candidateVotes'] as Map<String, dynamic>;
      final totalVotes = data['totalVotes'] as num;

      if (totalVotes == 0) return {};

      return candidateVotes.map(
            (candidateId, votes) => MapEntry(
          candidateId,
          (votes as num) / totalVotes * 100,
        ),
      );
    });
  }
}