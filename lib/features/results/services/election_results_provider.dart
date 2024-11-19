// lib/features/results/services/election_results_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import '../models/election_model.dart';
import '../../home/models/candidate_model.dart';
import '../../user_dashboard/services/vote_service_provider.dart';
import '../../auth/services/auth_service_provider.dart';

/// Combines the candidates and vote counts to provide the final candidates list
final candidatesStreamProvider = StreamProvider<List<ElectionCandidate>>((ref) {
  final voteService = ref.watch(voteServiceProvider);
  return voteService.watchCandidates().map((candidates) =>
      candidates.map((c) => ElectionCandidate(
        id: c.id,
        name: c.name,
        party: c.partyName,
        votes: 0.0,
      )).toList()
  );
});

/// Combines the candidates, vote counts, and total votes to provide the final
// election_results_provider.dart
// election_results_provider.dart
final formattedResultsProvider = StreamProvider<ElectionResults>((ref) {
  final voteService = ref.watch(voteServiceProvider);
  final authService = ref.watch(authServiceProvider);

  return Rx.combineLatest4(
    voteService.watchCandidates(),
    voteService.watchCandidateVoteCounts(),
    authService.watchTotalVotes(), // New stream to watch total registered users
    voteService.watchTotalVotes(),
        (List<Candidate> candidates, Map<String, int> voteCounts,
        int totalRegistered, int totalVoted) {

      // Calculate voted percentage from total registered users
      final votedPercentage = totalRegistered > 0
          ? (totalVoted / totalRegistered * 100)
          : 0.0;

      final candidatesData = candidates.map((c) {
        final votes = voteCounts[c.id] ?? 0;
        // Calculate percentage from total registered users
        final percentage = totalRegistered > 0
            ? (votes / totalRegistered * 100)
            : 0.0;

        return ElectionCandidate(
          id: c.id,
          name: c.name,
          party: c.partyName,
          votes: percentage,
        );
      }).toList();

      return ElectionResults(
        candidates: candidatesData,
        totalVotes: totalVoted,
        votedPercentage: votedPercentage,
        totalParties: candidates.map((c) => c.partyName).toSet().length,
      );
    },
  );
});
