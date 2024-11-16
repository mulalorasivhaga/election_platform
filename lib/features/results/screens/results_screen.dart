// lib/results/election_results_screen.dart
import 'package:election_platform/shared/widgets/main_navigator.dart';
import 'package:flutter/material.dart';
import 'package:election_platform/features/results/widgets/election_header.dart';
import 'package:election_platform/features/results/widgets/stats_row/election_stats_row.dart';
import 'package:election_platform/features/results/widgets/election_leaderboard/leaderboard.dart';
import 'package:election_platform/features/results/models/candidate_model.dart';


class ElectionResultsScreen extends StatelessWidget {
  // This would typically come from a state management solution or API
  final List<ElectionCandidate> _dummyCandidates = [
    const ElectionCandidate(name: 'John Doe', party: 'Party A', votes: 45),
    const ElectionCandidate(name: 'Jane Smith', party: 'Party B', votes: 30),
    const ElectionCandidate(name: 'Bob Johnson', party: 'Party C', votes: 25),
  ];

  ElectionResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      appBar: const MainNavigator(),
      body: RefreshIndicator(
        onRefresh: () async {
          // Implement refresh logic
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                /// This is the state class for the ElectionResultsScreen widget
                ElectionHeader(
                  headerText: 'National Election Results',
                  lastUpdated: DateTime.now(),
                ),
                const SizedBox(height: 24),
                ElectionStatsRow(
                  candidates: _dummyCandidates,
                  votedPercentage: 65.0,
                  totalVoters: 10000,
                  totalParties: 8,
                ),
                const SizedBox(height: 24),
                ElectionLeaderboard(
                  candidates: _dummyCandidates,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}