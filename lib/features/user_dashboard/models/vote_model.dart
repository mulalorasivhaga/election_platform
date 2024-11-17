// lib/models/vote.dart

class Vote {
  final String userId;      // Firebase Auth user ID
  final String saId;        // South African ID number
  final String candidateId; // Selected candidate's ID
  final DateTime timestamp;

  Vote({
    required this.userId,
    required this.saId,
    required this.candidateId,
    required this.timestamp,
  });

  /// This method converts a Vote object to a map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'saId': saId,
      'candidateId': candidateId,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// This method creates a Vote object from a map
  factory Vote.fromMap(Map<String, dynamic> map) {
    return Vote(
      userId: map['userId'] ?? '',
      saId: map['saId'] ?? '',
      candidateId: map['candidateId'] ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(),
    );
  }
}