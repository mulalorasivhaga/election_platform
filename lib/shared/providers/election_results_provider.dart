import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:election_platform/features/home/models/candidate_model.dart';
import 'package:election_platform/features/results/models/election_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

final logger = Logger();

final electionResultsProvider = StreamProvider<ElectionResults>((ref) {
  final firestore = FirebaseFirestore.instance;

  // Stream for candidates
  final candidatesStream = firestore
      .collection('candidates')
      .snapshots()
      .map((snapshot) {
    logger.d('Candidates data received: ${snapshot.docs.length} candidates');
    return snapshot.docs
        .map((doc) => Candidate.fromMap(doc.data(), doc.id))
        .toList();
  });

  // Stream for votes
  final votesStream = firestore
      .collection('votes')
      .snapshots()
      .map((snapshot) {
    logger.d('Votes data received: ${snapshot.docs.length} votes');
    // Count votes per candidate
    Map<String, int> voteCounts = {};
    for (var doc in snapshot.docs) {
      final candidateId = doc.data()['candidateId'] as String;
      voteCounts[candidateId] = (voteCounts[candidateId] ?? 0) + 1;
    }
    return voteCounts;
  });

  // Stream for total registered users (100 as per requirement)
  final totalRegisteredStream = Stream.value(100);

  return Rx.combineLatest3(
    candidatesStream,
    votesStream,
    totalRegisteredStream,
        (List<Candidate> candidates, Map<String, int> voteCounts, int totalRegistered) {
      logger.d('Combining streams with ${candidates.length} candidates and ${voteCounts.length} vote counts');

      // Calculate total votes
      final totalVoted = voteCounts.values.fold(0, (sum, count) => sum + count);
      final votedPercentage = totalRegistered > 0
          ? (totalVoted / totalRegistered * 100)
          : 0.0;

      final candidatesData = candidates.map((c) {
        final votes = voteCounts[c.id] ?? 0;
        final percentage = totalRegistered > 0
            ? (votes / totalRegistered * 100)
            : 0.0;

        return ElectionCandidate(
          id: c.id,
          name: c.name,
          party: c.partyName,
          votes: percentage,
        );
      }).toList()
        ..sort((a, b) => b.votes.compareTo(a.votes)); // Sort by votes

      logger.i('Election results processed: ${candidatesData.length} candidates, $votedPercentage% turnout');

      return ElectionResults(
        candidates: candidatesData,
        totalVotes: totalVoted,
        votedPercentage: votedPercentage,
        totalParties: candidates.map((c) => c.partyName).toSet().length,
      );
    },
  ).handleError((error) {
    logger.e('Error in election results stream: $error');
    return ElectionResults(
      candidates: [],
      totalVotes: 0,
      votedPercentage: 0.0,
      totalParties: 0,
    );
  });
});

// Separate provider for candidates list
final candidatesProvider = StreamProvider<List<Candidate>>((ref) {
  return FirebaseFirestore.instance
      .collection('candidates')
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => Candidate.fromMap(doc.data(), doc.id))
      .toList());
});