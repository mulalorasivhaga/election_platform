// lib/features/home/models/candidate_model.dart

class Candidate {
  final String id;
  final String name;
  final String partyName;
  final String manifesto;
  final String imagePath;

  Candidate({
    required this.id,
    required this.name,
    required this.partyName,
    required this.manifesto,
    required this.imagePath,
  });

  // Convert Candidate object to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'partyName': partyName,
      'manifesto': manifesto,
      'imagePath': imagePath,
    };
  }

  // Create Candidate object from a Map
  factory Candidate.fromMap(Map<String, dynamic> map, String documentId) {
    return Candidate(
      id: documentId,
      name: map['name'] ?? '',
      partyName: map['partyName'] ?? '',
      manifesto: map['manifesto'] ?? '',
      imagePath: map['imagePath'] ?? '',
    );
  }

  // Create a copy of Candidate with some fields replaced
  Candidate copyWith({
    String? id,
    String? name,
    String? partyName,
    String? manifesto,
    String? imagePath,
  }) {
    return Candidate(
      id: id ?? this.id,
      name: name ?? this.name,
      partyName: partyName ?? this.partyName,
      manifesto: manifesto ?? this.manifesto,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  String toString() {
    return 'Candidate(id: $id, name: $name, partyName: $partyName, imagePath: $imagePath)';
  }
}