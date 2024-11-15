// lib/results/widgets/election_stats_row/candidate_count_card.dart

import 'package:flutter/material.dart';
import 'package:election_platform/features/results/utils/election_chart_color.dart';
import 'package:election_platform/features/results/models/candidate_model.dart';

class CandidateCountCard extends StatelessWidget {
  final List<ElectionCandidate> candidates;
  final int totalParties;

  const CandidateCountCard({
    super.key,
    required this.candidates,
    required this.totalParties,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Candidates',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ElectionChartColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildCandidatesGrid(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCandidatesGrid() {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: ElectionChartColors.primary.withOpacity(0.1),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: const Row(
            children: [
              SizedBox(
                width: 50,
                child: Text(
                  'No.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ElectionChartColors.textPrimary,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Candidate',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ElectionChartColors.textPrimary,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Party',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ElectionChartColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Candidates List
        Container(
          constraints: const BoxConstraints(maxHeight: 300),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: candidates.length,
            itemBuilder: (context, index) {
              final candidate = candidates[index];
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: ElectionChartColors.secondary.withOpacity(0.3),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 50,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: ElectionChartColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          candidate.name,
                          style: const TextStyle(
                            color: ElectionChartColors.textPrimary,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          candidate.party,
                          style: const TextStyle(
                            color: ElectionChartColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Footer
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: ElectionChartColors.secondary.withOpacity(0.1),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Candidates: ${candidates.length}',
                style: const TextStyle  (
                  fontWeight: FontWeight.bold,
                    color: ElectionChartColors.textPrimary,
                ),
              ),
              const Text(
                'Total Parties: 3',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ElectionChartColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}