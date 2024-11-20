// lib/screens/election_results_screen.dart
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
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFCCA43B)),
          ),
        ),
        error: (err, stack) => Center(
          child: Text(
            'Error: $err',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        data: (results) {
          return SingleChildScrollView(
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
                    totalVoters: 100,
                    totalParties: results.totalParties,
                  ),
                  const SizedBox(height: 24),
                  ElectionLeaderboard(
                    candidates: results.candidates,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}