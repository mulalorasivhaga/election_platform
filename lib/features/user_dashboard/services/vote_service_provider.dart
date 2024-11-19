// lib/providers/vote_service_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/vote_service.dart';

// Create a provider for the VoteService
final voteServiceProvider = Provider<VoteService>((ref) {
  return VoteService();
});

// Provider for real-time vote counts
final voteCountsProvider = StreamProvider<Map<String, int>>((ref) {
  final voteService = ref.watch(voteServiceProvider);
  return voteService.watchCandidateVoteCounts();
});

// Provider for total votes
final totalVotesProvider = StreamProvider<int>((ref) {
  final voteService = ref.watch(voteServiceProvider);
  return voteService.watchTotalVotes();
});

// Provider for provincial results
final provincialResultsProvider = StreamProvider<Map<String, Map<String, int>>>((ref) {
  final voteService = ref.watch(voteServiceProvider);
  return voteService.watchProvinceVotes();
});

// Provider to check if a user has voted
final hasUserVotedProvider = FutureProvider.family<bool, String>((ref, userId) {
  final voteService = ref.watch(voteServiceProvider);
  return voteService.hasUserVoted(userId);
});