import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/results_navigator.dart';
import 'package:election_platform/shared/providers/election_results_provider.dart';
import '../widgets/election_header.dart';
import '../widgets/stats_row/election_stats_row.dart';
import '../widgets/election_leaderboard/leaderboard.dart';

class ElectionResultsScreen extends ConsumerWidget {
  const ElectionResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(electionResultsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF242F40),
      appBar: const DisplayResultsNavigator(),
      body: resultsAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFCCA43B)),
              ),
              SizedBox(height: 16),
              Text(
                'Loading election results...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        error: (error, stackTrace) {
          logger.e('Error displaying results', error: error, stackTrace: stackTrace);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Error: ${error.toString()}',
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(electionResultsProvider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCCA43B),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        },
        data: (results) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElectionHeader(
                  headerText: 'National Election Results',
                  lastUpdated: DateTime.now(),
                ),
                const SizedBox(height: 24),
                ElectionStatsRow(
                  candidates: results.candidates,
                  votedPercentage: results.votedPercentage,
                  totalVoters: results.totalVotes,
                  totalParties: results.totalParties,
                ),
                const SizedBox(height: 24),
                ElectionLeaderboard(
                  candidates: results.candidates,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}