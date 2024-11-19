// lib/utils/candidate_mapper.dart
import 'package:election_platform/features/home/models/candidate_model.dart';
import '../models/election_model.dart';

class CandidateMapper {
  static ElectionCandidate fromCandidate(Candidate candidate, double votes) {
    return ElectionCandidate(
      id: candidate.id,
      name: candidate.name,
      party: candidate.partyName,
      votes: votes,
    );
  }
  /// Create a map of election candidates from a list of candidates and a map of vote counts.
  static Map<String, ElectionCandidate> createCandidateMap(
      List<Candidate> candidates,
      Map<String, int> voteCounts,
      ) {
    final totalVotes = voteCounts.values.fold(0, (sum, count) => sum + count);

    return Map.fromEntries(
      candidates.map((candidate) {
        final votes = voteCounts[candidate.id]?.toDouble() ?? 0.0;
        final percentage = totalVotes > 0
            ? ((votes / totalVotes) * 100)
            : 0.0;

        return MapEntry(
          candidate.id,
          ElectionCandidate(
            id: candidate.id,
            name: candidate.name,
            party: candidate.partyName,
            votes: percentage,
          ),
        );
      }),
    );
  }
}