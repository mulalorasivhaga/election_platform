// lib/services/candidate_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../../features/home/models/candidate_model.dart';

class CandidateService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'candidates';
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );

  // Get a stream of all candidates
  Stream<List<Candidate>> getCandidates() {
    _logger.i('Fetching all candidates stream');
    return _firestore
        .collection(_collection)
        .snapshots()
        .map((snapshot) {
      _logger.d('Received ${snapshot.docs.length} candidates from Firestore');
      return snapshot.docs.map((doc) {
        return Candidate.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Get a single candidate by ID
  Future<Candidate?> getCandidateById(String id) async {
    try {
      _logger.i('Fetching candidate with ID: $id');
      final doc = await _firestore.collection(_collection).doc(id).get();

      if (doc.exists && doc.data() != null) {
        _logger.d('Found candidate with ID: $id');
        return Candidate.fromMap(doc.data()!, doc.id);
      }

      _logger.w('No candidate found with ID: $id');
      return null;
    } catch (e, stackTrace) {
      _logger.e('Error getting candidate by ID: $id',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Add a new candidate
  Future<void> addCandidate(Candidate candidate) async {
    try {
      _logger.i('Adding new candidate: ${candidate.name}');
      await _firestore.collection(_collection).add(candidate.toMap());
      _logger.d('Successfully added candidate: ${candidate.name}');
    } catch (e, stackTrace) {
      _logger.e('Error adding candidate: ${candidate.name}',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Update an existing candidate
  Future<void> updateCandidate(Candidate candidate) async {
    try {
      _logger.i('Updating candidate: ${candidate.name} (ID: ${candidate.id})');
      await _firestore
          .collection(_collection)
          .doc(candidate.id)
          .update(candidate.toMap());
      _logger.d('Successfully updated candidate: ${candidate.name}');
    } catch (e, stackTrace) {
      _logger.e('Error updating candidate: ${candidate.name}',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Delete a candidate
  Future<void> deleteCandidate(String id) async {
    try {
      _logger.i('Deleting candidate with ID: $id');
      await _firestore.collection(_collection).doc(id).delete();
      _logger.d('Successfully deleted candidate with ID: $id');
    } catch (e, stackTrace) {
      _logger.e('Error deleting candidate with ID: $id',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Get candidates by party name
  Stream<List<Candidate>> getCandidatesByParty(String partyName) {
    _logger.i('Fetching candidates for party: $partyName');
    return _firestore
        .collection(_collection)
        .where('partyName', isEqualTo: partyName)
        .snapshots()
        .map((snapshot) {
      _logger.d('Received ${snapshot.docs.length} candidates from party: $partyName');
      return snapshot.docs.map((doc) {
        return Candidate.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Search candidates by name
  Stream<List<Candidate>> searchCandidates(String searchTerm) {
    _logger.i('Searching candidates with term: $searchTerm');
    return _firestore
        .collection(_collection)
        .orderBy('name')
        .startAt([searchTerm])
        .endAt(['$searchTerm\uf8ff'])
        .snapshots()
        .map((snapshot) {
      _logger.d('Found ${snapshot.docs.length} candidates matching: $searchTerm');
      return snapshot.docs.map((doc) {
        return Candidate.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Get total number of candidates
  Future<int?> getCandidateCount() async {
    try {
      _logger.i('Getting total candidate count');
      final snapshot = await _firestore.collection(_collection).count().get();
      _logger.d('Total candidates count: ${snapshot.count}');
      return snapshot.count;
    } catch (e, stackTrace) {
      _logger.e('Error getting candidate count',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Dispose of logger resources when service is no longer needed
  void dispose() {
    _logger.d('Disposing CandidateService');
  }
}