// lib/results/widgets/election_leaderboard/leaderboard.dart

import 'package:flutter/material.dart';
import 'package:election_platform/features/results/models/election_model.dart';
import 'package:election_platform/features/results/utils/election_chart_color.dart';
import 'package:election_platform/features/results/widgets/election_leaderboard/leaderboard_candidate_item.dart';

class ElectionLeaderboard extends StatelessWidget {
  final List<ElectionCandidate> candidates;

  const ElectionLeaderboard({
    super.key,
    required this.candidates,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate total votes and normalize percentages
    final totalVotes = candidates.fold(0.0, (sum, c) => sum + c.votes);
    final normalizedCandidates = candidates.map((c) {
      final normalizedVotes = totalVotes > 0 ? (c.votes / totalVotes * 100) : 0.0;
      return ElectionCandidate(
        id: c.id,
        name: c.name,
        party: c.party,
        votes: normalizedVotes,
      );
    }).toList();

    final sortedCandidates = [...normalizedCandidates]
      ..sort((a, b) => b.votes.compareTo(a.votes));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Candidates',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ElectionChartColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sortedCandidates.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) => LeaderboardCandidateItem(
                candidate: sortedCandidates[index],
                position: index + 1,
                isTopThree: index < 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}