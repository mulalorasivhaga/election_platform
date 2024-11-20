// lib/results/widgets/election_leaderboard/leaderboard_candidate_item.dart

import 'package:flutter/material.dart';
import 'package:election_platform/features/results/models/election_model.dart';
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

  /// Builds the candidate leaderboard item
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isTopThree
            ? const Color(0xFF242F40).withOpacity(0.05)
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

  /// Returns the position widget
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

  /// Returns the candidate information widget
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

/// Returns the vote percentage widget
  Widget _buildVotePercentage() {
    // Ensure we always have a valid number to display
    final displayPercentage = candidate.votes.isNaN ? 0.0 : candidate.votes;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: isTopThree
            ? const Color(0xFFCCA43B).withOpacity(0.1)
            : const Color(0xFF242F40).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '${displayPercentage.toStringAsFixed(2)}%',
        style: TextStyle(
          color: isTopThree
              ? const Color(0xFFCCA43B)
              : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}