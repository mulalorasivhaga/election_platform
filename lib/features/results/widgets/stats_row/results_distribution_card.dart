// lib/results/widgets/election_stats_row/results_distribution_card.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:election_platform/features/results/utils/election_chart_color.dart';
import 'package:election_platform/features/results/models/candidate_model.dart';
import '../../utils/election_chart_utils.dart';

class ResultsDistributionCard extends StatelessWidget {
  final List<ElectionCandidate> candidates;

  const ResultsDistributionCard({
    super.key,
    required this.candidates,
  });

  /// Builds the card with the national results distribution
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'National Results Distribution',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ElectionChartColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: PieChart(
                      PieChartData(
                        sections: ElectionChartUtils.getCandidateResultsSections(
                          candidates: candidates,
                        ),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: _buildLegend(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the legend for the chart
  Widget _buildLegend() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        candidates.length,
            (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: ElectionChartColors.getPartyColor(index),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${candidates[index].party} (${candidates[index].votes}%)',
                  style: const TextStyle(
                    fontSize: 12,
                    color: ElectionChartColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}