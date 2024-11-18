// lib/exceptions/vote_exception.dart

class VoteException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const VoteException(
      this.message, {
        this.code,
        this.details,
      });

  @override
  String toString() => message;

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      if (code != null) 'code': code,
      if (details != null) 'details': details,
    };
  }

  static VoteException fromMap(Map<String, dynamic> map) {
    return VoteException(
      map['message'] as String,
      code: map['code'] as String?,
      details: map['details'],
    );
  }

  // Common vote exceptions
  static const VoteException invalidId = VoteException(
    'Invalid ID number format',
    code: 'INVALID_ID',
  );

  static const VoteException alreadyVoted = VoteException(
    'You have already cast your vote',
    code: 'ALREADY_VOTED',
  );

  static const VoteException invalidCandidate = VoteException(
    'Invalid candidate selection',
    code: 'INVALID_CANDIDATE',
  );

  static const VoteException idMismatch = VoteException(
    'ID number does not match your profile',
    code: 'ID_MISMATCH',
  );

  static const VoteException systemError = VoteException(
    'An error occurred while processing your vote',
    code: 'SYSTEM_ERROR',
  );

  static const VoteException missingFields = VoteException(
    'Missing required fields',
    code: 'MISSING_FIELDS',
  );
}