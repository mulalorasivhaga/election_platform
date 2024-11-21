// ignore_for_file: avoid_types_as_parameter_names

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:election_platform/features/home/models/candidate_model.dart';
import 'package:election_platform/features/results/models/election_model.dart';
import 'package:logger/logger.dart';

final logger = Logger();


final electionResultsProvider = StreamProvider<ElectionResults>((ref) {
  final firestore = FirebaseFirestore.instance;

  return firestore.collection('votes').snapshots().asyncMap((votesSnapshot) async {
    // Get candidates first with null safety
    final candidatesSnapshot = await firestore.collection('candidates').get();
    final candidates = candidatesSnapshot.docs
        .map((doc) => Candidate.fromMap(doc.data(), doc.id))
        .toList();

    // Count national votes with null checks
    Map<String, int> nationalVotes = {};
    for (var doc in votesSnapshot.docs) {
      final data = doc.data();
      final nationalCandidateId = data['nationalCandidateId'] as String?;
      if (nationalCandidateId != null) {
        nationalVotes[nationalCandidateId] = (nationalVotes[nationalCandidateId] ?? 0) + 1;
      }
    }

    // Calculate totals with null safety
    final totalVotes = nationalVotes.values.fold(0, (sum, count) => sum + count);
    final votedPercentage = 100 * (totalVotes / 100); // 100 total voters

    // Create election candidates with null checks
    final electionCandidates = candidates.map((candidate) {
      final votes = nationalVotes[candidate.id] ?? 0;
      final percentage = totalVotes > 0 ? (votes / totalVotes * 100) : 0.0;

      return ElectionCandidate(
        id: candidate.id,
        name: candidate.name,
        party: candidate.partyName,
        votes: percentage,
      );
    }).toList()..sort((a, b) => b.votes.compareTo(a.votes));

    return ElectionResults(
      candidates: electionCandidates,
      totalVotes: totalVotes,
      votedPercentage: votedPercentage,
      totalParties: candidates.length,
    );
  });
});

final provincialResultsProvider = StreamProvider<Map<String, List<ElectionCandidate>>>((ref) {
  final firestore = FirebaseFirestore.instance;

  return firestore.collection('votes').snapshots().asyncMap((votesSnapshot) async {
    // Get candidates first with null safety
    final candidatesSnapshot = await firestore.collection('candidates').get();
    final candidates = candidatesSnapshot.docs
        .map((doc) => Candidate.fromMap(doc.data(), doc.id))
        .toList();

    Map<String, Map<String, int>> provinceVotes = {};

    // Process votes by province with null checks
    for (var doc in votesSnapshot.docs) {
      final data = doc.data();
      final province = data['province'] as String?;
      final candidateId = data['provincialCandidateId'] as String?;

      if (province != null && candidateId != null) {
        provinceVotes.putIfAbsent(province, () => {});
        provinceVotes[province]![candidateId] = (provinceVotes[province]![candidateId] ?? 0) + 1;
      }
    }

    // Calculate percentages for each province with null safety
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
