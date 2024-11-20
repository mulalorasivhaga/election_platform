// lib/models/election_model.dart
class ElectionResults {
  final List<ElectionCandidate> candidates;
  final int totalVotes;
  final double votedPercentage;
  final int totalParties;

  ElectionResults({
    required this.candidates,
    required this.totalVotes,
    required this.votedPercentage,
    required this.totalParties,
  });
}

class ElectionCandidate {
  final String id;
  final String name;
  final String party;
  final double votes;

  ElectionCandidate({
    required this.id,
    required this.name,
    required this.party,
    required this.votes,
  });
}