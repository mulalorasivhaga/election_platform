// lib/results/utils/election_chart_utils.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:election_platform/features/results/utils/election_chart_color.dart';
import 'package:election_platform/features/results/models/election_model.dart';

class ElectionChartUtils {
  static List<PieChartSectionData> getVoterTurnoutSections({
    required double votedPercentage,
    double radius = 80,
  }) {
    return [
      PieChartSectionData(
        value: votedPercentage,
        title: '${votedPercentage.toStringAsFixed(1)}%',
        color: ElectionChartColors.turnoutVoted,
        radius: radius,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: 100 - votedPercentage,
        title: '${(100 - votedPercentage).toStringAsFixed(1)}%',
        color: ElectionChartColors.turnoutNotVoted,
        radius: radius,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
      ),
    ];
  }
  /// Returns a list of PieChartSectionData objects representing the results of the election.
  static List<PieChartSectionData> getCandidateResultsSections({
    required List<ElectionCandidate> candidates,
    double radius = 80,
  }) {
    // Calculate total votes
    final totalVotes = candidates.fold(0.0, (sum, candidate) => sum + candidate.votes);

    // Normalize percentages to ensure they sum to 100%
    return List.generate(
      candidates.length,
          (index) {
        final normalizedPercentage = totalVotes > 0
            ? (candidates[index].votes / totalVotes * 100)
            : 0.0;

        return PieChartSectionData(
          value: normalizedPercentage,
          title: '${normalizedPercentage.toStringAsFixed(1)}%',
          color: ElectionChartColors.getPartyColor(index),
          radius: radius,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      },
    );
  }

  /// Returns a BarChartData object representing the results of the election.
  static BarChartData getProvinceBarChartData({
    required Map<String, double> provincialData,
    double maxY = 100,
  }) {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: maxY,
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final provinces = provincialData.keys.toList();
              if (value >= 0 && value < provinces.length) {
                return RotatedBox(
                  quarterTurns: 1,
                  child: Text(
                    provinces[value.toInt()],
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              }
              return const Text('');
            },
          ),
        ),
      ),
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      barGroups: _getBarGroups(provincialData),
    );
  }

  /// Returns a list of BarChartGroupData objects representing the results of the election.
  static List<BarChartGroupData> _getBarGroups(Map<String, double> provincialData) {
    return List.generate(
      provincialData.length,
          (index) => BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: provincialData.values.elementAt(index),
            color: ElectionChartColors.getPartyColor(index),
            width: 16,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      ),
    );
  }
}