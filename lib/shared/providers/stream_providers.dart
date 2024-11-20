// lib/shared/providers/stream_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:election_platform/features/home/models/candidate_model.dart';
import 'service_providers.dart';

final candidatesStreamProvider = StreamProvider<List<Candidate>>((ref) {
  final voteService = ref.watch(voteServiceProvider);
  return voteService.watchCandidates();
});

final voteCountsProvider = StreamProvider<Map<String, int>>((ref) {
  final voteService = ref.watch(voteServiceProvider);
  return voteService.watchCandidateVoteCounts();
});