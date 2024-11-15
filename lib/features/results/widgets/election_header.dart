// lib/results/widgets/election_header.dart

import 'package:flutter/material.dart';
import 'package:election_platform/features/results/utils/election_chart_color.dart';

class ElectionHeader extends StatelessWidget {
  final DateTime lastUpdated;

  const ElectionHeader({
    super.key,
    required this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'National Results',
          style: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
            color: ElectionChartColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Latest election results as of ${_formatDateTime(lastUpdated)}',
          style: const TextStyle(
            fontSize: 16,
            color: ElectionChartColors.textSecondary,
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}