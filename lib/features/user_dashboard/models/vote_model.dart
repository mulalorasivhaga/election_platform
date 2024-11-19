// lib/models/vote.dart
class Vote {
  final String userId;
  final String candidateId;
  final DateTime timestamp;
  final String province;

  Vote({
    required this.userId,
    required this.candidateId,
    required this.timestamp,
    required this.province,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'candidateId': candidateId,
      'timestamp': timestamp.toIso8601String(),
      'province': province,
    };
  }

  factory Vote.fromMap(Map<String, dynamic> map) {
    return Vote(
      userId: map['userId'] ?? '',
      candidateId: map['candidateId'] ?? '',
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])
          : DateTime.now(),
      province: map['province'] ?? '',
    );
  }
}