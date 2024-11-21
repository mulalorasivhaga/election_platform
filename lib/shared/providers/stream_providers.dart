// lib/shared/providers/stream_providers.dart
// ignore_for_file: avoid_types_as_parameter_names

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:election_platform/features/home/models/candidate_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/results/models/election_model.dart';

/// create a logger instance
final candidatesProvider = StreamProvider<List<Candidate>>((ref) {
  return FirebaseFirestore.instance
      .collection('candidates')
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => Candidate.fromMap(doc.data(), doc.id))
      .toList());
});

/// create a logger instance
final provincialResultsProvider = StreamProvider<Map<String, List<ElectionCandidate>>>((ref) {
  return FirebaseFirestore.instance.collection('votes').snapshots().asyncMap((votesSnapshot) async {
    final candidatesSnapshot = await FirebaseFirestore.instance.collection('candidates').get();
    final candidates = candidatesSnapshot.docs
        .map((doc) => Candidate.fromMap(doc.data(), doc.id))
        .toList();

    Map<String, Map<String, int>> provinceVotes = {};

    for (var doc in votesSnapshot.docs) {
      final data = doc.data();
      final province = data['province_votes'] as String? ?? 'Unknown';
      final candidateId = data['CandidateId'] as String? ?? 'Unknown';

      provinceVotes.putIfAbsent(province, () => {});
      provinceVotes[province]![candidateId] = (provinceVotes[province]![candidateId] ?? 0) + 1;
    }

    return provinceVotes.map((province, votes) {
      final totalVotes = votes.values.fold(0, (sum, count) => sum + count);

      return MapEntry(
        province,
        candidates.map((candidate) {
          final candidateVotes = votes[candidate.id] ?? 0;
          final percentage = totalVotes > 0 ? (candidateVotes / totalVotes * 100) : 0.0;

          return ElectionCandidate(
            id: candidate.id,
            name: candidate.name,
            party: candidate.partyName,
            votes: percentage,
          );
        }).toList()..sort((a, b) => b.votes.compareTo(a.votes)),
      );
    });
  });
});