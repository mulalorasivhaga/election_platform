// lib/models/vote.dart

class Vote {
  final String userId;
  final String candidateId;
  final DateTime timestamp;

  Vote({
    required this.userId,
    required this.candidateId,
    required this.timestamp,
  });
  /// This method converts a vote object to a map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'candidateId': candidateId,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// This method converts a map to a vote object
  factory Vote.fromMap(Map<String, dynamic> map) {
    return Vote(
      userId: map['userId'] ?? '',
      candidateId: map['candidateId'] ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(),
    );
  }
}