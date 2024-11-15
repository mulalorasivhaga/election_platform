// lib/results/widgets/election_leaderboard/leaderboard_candidate_item.dart

import 'package:flutter/material.dart';
import 'package:election_platform/features/results/models/candidate_model.dart';
import 'package:election_platform/features/results/utils/election_chart_color.dart';

class LeaderboardCandidateItem extends StatelessWidget {
  final ElectionCandidate candidate;
  final int position;
  final bool isTopThree;

  const LeaderboardCandidateItem({
    super.key,
    required this.candidate,
    required this.position,
    this.isTopThree = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isTopThree
            ? ElectionChartColors.primary.withOpacity(0.05)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildPosition(),
          const SizedBox(width: 16),
          _buildCandidateInfo(),
          _buildVotePercentage(),
        ],
      ),
    );
  }

  Widget _buildPosition() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isTopThree
            ? ElectionChartColors.primary.withOpacity(0.1)
            : ElectionChartColors.secondary.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          position.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isTopThree
                ? ElectionChartColors.primary
                : ElectionChartColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildCandidateInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            candidate.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isTopThree
                  ? ElectionChartColors.textPrimary
                  : ElectionChartColors.textSecondary,
            ),
          ),
          Text(
            candidate.party,
            style: const TextStyle(
              color: ElectionChartColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVotePercentage() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: isTopThree
            ? ElectionChartColors.primary.withOpacity(0.1)
            : ElectionChartColors.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '${candidate.votes}%',
        style: TextStyle(
          color: isTopThree
              ? ElectionChartColors.primary
              : ElectionChartColors.textSecondary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}