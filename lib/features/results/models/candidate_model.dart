// lib/results/models/candidate_model.dart

class ElectionCandidate {
  final String name;
  final String party;
  final int votes;
  final String? imageUrl;

  const ElectionCandidate({
    required this.name,
    required this.party,
    required this.votes,
    this.imageUrl,
  });

  factory ElectionCandidate.fromMap(Map<String, dynamic> map) {
    return ElectionCandidate(
      name: map['name'] as String,
      party: map['party'] as String,
      votes: map['votes'] as int,
      imageUrl: map['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'party': party,
      'votes': votes,
      'imageUrl': imageUrl,
    };
  }
}