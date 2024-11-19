import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

// Create a provider for the VoteService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Provider for real-time vote counts
final voteCountsProvider = StreamProvider<Map<String, int>>((ref) {
  final voteService = ref.watch(authServiceProvider);
  return voteService.watchCandidateVoteCounts();
});

// Provider for total votes
final totalVotesProvider = StreamProvider<int>((ref) {
  final voteService = ref.watch(authServiceProvider);
  return voteService.watchTotalVotes();
});

// Provider for provincial results
final provincialResultsProvider = StreamProvider<Map<String, Map<String, int>>>((ref) {
  final voteService = ref.watch(authServiceProvider);
  return voteService.watchProvinceVotes();
});

// Provider to check if a user has voted
final hasUserVotedProvider = FutureProvider.family<bool, String>((ref, userId) {
  final voteService = ref.watch(authServiceProvider);
  return voteService.hasUserVoted(userId);
});