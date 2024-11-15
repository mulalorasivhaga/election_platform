// lib/results/widgets/election_stats_row/election_stats_row.dart

import 'package:flutter/material.dart';
import 'package:election_platform/features/results/models/candidate_model.dart';
import 'package:election_platform/features/results/widgets/stats_row/turnout_stat_card.dart';
import 'candidate_count_card.dart';
import 'results_distribution_card.dart';


class ElectionStatsRow extends StatelessWidget {
  final List<ElectionCandidate> candidates;
  final double votedPercentage;
  final int totalVoters;
  final int totalParties;

  const ElectionStatsRow({
    super.key,
    required this.candidates,
    required this.votedPercentage,
    required this.totalVoters,
    required this.totalParties,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return _buildWideLayout();
        } else {
          return _buildNarrowLayout();
        }
      },
    );
  }

  Widget _buildWideLayout() {
    return SizedBox(
      height: 400,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: TurnoutStatsCard(
              votedPercentage: votedPercentage,
              totalVoters: totalVoters,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CandidateCountCard(
              candidates: candidates,
              totalParties: totalParties,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ResultsDistributionCard(
              candidates: candidates,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNarrowLayout() {
    return Column(
      children: [
        TurnoutStatsCard(
          votedPercentage: votedPercentage,
          totalVoters: totalVoters,
        ),
        const SizedBox(height: 16),
        CandidateCountCard(
          candidates: candidates,
          totalParties: totalParties,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: ResultsDistributionCard(
            candidates: candidates,
          ),
        ),
      ],
    );
  }
}