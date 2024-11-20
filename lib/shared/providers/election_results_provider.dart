import 'package:election_platform/shared/providers/service_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:election_platform/features/home/models/candidate_model.dart';
import 'package:election_platform/features/results/models/election_model.dart';



final electionResultsProvider = StreamProvider<ElectionResults>((ref) {
  final voteService = ref.watch(voteServiceProvider);
  final authService = ref.watch(authServiceProvider);

  return Rx.combineLatest4(
    voteService.watchCandidates(),
    voteService.watchCandidateVoteCounts(),
    authService.watchTotalVotes(),
    voteService.watchTotalVotes(),
        (List<Candidate> candidates, Map<String, int> voteCounts,
        int totalRegistered, int totalVoted) {

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

// Add a provider for watching candidates directly
final candidatesStreamProvider = StreamProvider<List<Candidate>>((ref) {
  final voteService = ref.watch(voteServiceProvider);
  return voteService.watchCandidates();
});