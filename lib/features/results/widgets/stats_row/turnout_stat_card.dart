// lib/results/widgets/election_stats_row/turnout_stats_card.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:election_platform/features/results/utils/election_chart_color.dart';
import '../../utils/election_chart_utils.dart';

/// A card that displays the voter turnout stats for an election
class TurnoutStatsCard extends StatelessWidget {
  final double votedPercentage;
  final int totalVoters;

  const TurnoutStatsCard({
    super.key,
    required this.votedPercentage,
    required this.totalVoters,
  });

  /// Builds the card with the voter turnout stats
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Voter Turnout',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ElectionChartColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            // Pie chart showing voter turnout
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: ElectionChartUtils.getVoterTurnoutSections(
                    votedPercentage: votedPercentage,
                  ),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 50),


            /// Add the legend items for the voted and not voted percentages
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendItem(
                  color: ElectionChartColors.turnoutVoted,
                  label: 'Voted (${votedPercentage.toStringAsFixed(1)}%)',
                ),
                const SizedBox(width: 16),
                _LegendItem(
                  color: ElectionChartColors.turnoutNotVoted,
                  label: 'Not Voted (${(100 - votedPercentage).toStringAsFixed(1)}%)',
                ),
              ],
            ),
            const SizedBox(height: 8),

            /// Display the total eligible voters
            const Center(
              child: Text(
                'Total Eligible Voters: 100',
                style: TextStyle(
                  fontSize: 14,
                  color: ElectionChartColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A legend item for the voter turnout stats
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  /// Constructor
  const _LegendItem({
    required this.color,
    required this.label,
  });

  /// Builds the legend item
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: ElectionChartColors.textSecondary,
          ),
        ),
      ],
    );
  }
}