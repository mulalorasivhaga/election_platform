// lib/results/widgets/election_leaderboard/leaderboard.dart

import 'package:flutter/material.dart';
import 'package:election_platform/features/results/models/candidate_model.dart';
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
    final sortedCandidates = [...candidates]
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