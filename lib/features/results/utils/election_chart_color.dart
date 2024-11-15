// lib/results/utils/election_chart_colors.dart

import 'package:flutter/material.dart';


class ElectionChartColors {
  // General colors
  static const Color primary =  Color(0xFF242F40);
  static const Color secondary = Color(0xFF242F40);

  // Text colors
  static const Color textPrimary = Color(0xFFCCA43B);
  static const Color textSecondary = Color(0xFF242F40);

  // Card colors
  static const Color cardBackground = Color(0xFF242F40);
  static const Color cardHeaderBackground = Color(0xFFF5F5F5);
  static const Color cardBorder = Color(0xFFEEEEEE);

  // Party colors
  static const List<Color> partyColors = [
    Color(0xFF2196F3), // Blue
    Color(0xFFF44336), // Red
    Color(0xFF4CAF50), // Green
    Color(0xFFFF9800), // Orange
    Color(0xFF9C27B0), // Purple
  ];

  // Gradient colors
  static const List<Color> gradientColors = [
    Color(0xFF1976D2),
    Color(0xFF2196F3),
    Color(0xFF64B5F6),
  ];

  // Get party color by index
  static Color getPartyColor(int index) {
    return partyColors[index % partyColors.length];
  }

  // Chart specific colors
  static const Color turnoutVoted = Color(0xFF2196F3);
  static const Color turnoutNotVoted = Color(0xFFE0E0E0);
  static const Color chartBackground = Colors.white;
  static const Color gridLines = Color(0xFFECECEC);
}