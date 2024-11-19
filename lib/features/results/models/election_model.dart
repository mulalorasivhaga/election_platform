// lib/features/results/models/election_model.dart
class ElectionCandidate {
  final String id;
  final String name;
  final String party;
  final double votes;

  const ElectionCandidate({
    required this.id,
    required this.name,
    required this.party,
    required this.votes,
  });
}

class ElectionResults {
  final List<ElectionCandidate> candidates;
  final int totalVotes;
  final double votedPercentage;
  final int totalParties;

  const ElectionResults({
    required this.candidates,
    required this.totalVotes,
    required this.votedPercentage,
    required this.totalParties,
  });
}