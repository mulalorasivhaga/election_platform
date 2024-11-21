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

  // Factory constructor to create an empty ElectionCandidate
  factory ElectionCandidate.empty() {
    return ElectionCandidate(
      id: '',
      name: '',
      party: '',
      votes: 0.0,
    );
  }
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

  factory ElectionResults.empty() {
    return const ElectionResults(
      candidates: [],
      totalVotes: 0,
      votedPercentage: 0.0,
      totalParties: 0,
    );
  }
}