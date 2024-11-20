// lib/screens/home_screen.dart

import 'package:election_platform/shared/widgets/main_navigator.dart';
import 'package:flutter/material.dart';
import '../../../shared/services/candidate_service.dart';
import '../models/candidate_model.dart';
import '../widgets/manifesto_dialog.dart';
import 'package:logger/logger.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// This class is the state for the HomeScreen widget
class _HomeScreenState extends State<HomeScreen> {
  final CandidateService _candidateService = CandidateService();
  final Logger _logger = Logger();

  int _getCrossAxisCount(double width) {
    if (width > 1200) {
      return 3;  // Show 3 cards per row on large screens
    } else if (width > 800) {
      return 2;  // Show 2 cards per row on medium screens
    } else {
      return 1;  // Show 1 card per row on small screens
    }
  }

  /// This method builds the header section
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      appBar: const MainNavigator(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1400),
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth > 600 ? 48.0 : 16.0,
                  vertical: 24.0,
                ),
                child: Column(
                  children: [
                    _buildHeader(constraints),
                    const SizedBox(height: 48),
                    _buildCandidateGrid(constraints),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// This method builds the header section
  Widget _buildHeader(BoxConstraints constraints) {
    final bool isMobile = constraints.maxWidth <= 600;

    return Column(
      children: [
        Text(
          'Welcome to Election Platform',
          style: TextStyle(
            color: const Color(0xFFCCA43B),
            fontSize: isMobile ? 36 : 72,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isMobile ? constraints.maxWidth * 0.9 : 800,
          ),
          child: const Text(
            "Your trusted platform for secure and confidential voting in South Africa.",
            style: TextStyle(
              color: Color(0xFF242F40),
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  /// This method builds the candidate grid
  Widget _buildCandidateGrid(BoxConstraints constraints) {
    return StreamBuilder<List<Candidate>>(
      stream: _candidateService.getCandidates(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFCCA43B),
            ),
          );
        }

        final candidates = snapshot.data ?? [];
        final crossAxisCount = _getCrossAxisCount(constraints.maxWidth);
        final itemWidth = (constraints.maxWidth - (32.0 * (crossAxisCount - 1))) / crossAxisCount;

        return Wrap(
          spacing: 32,
          runSpacing: 32,
          alignment: WrapAlignment.center,
          children: candidates.map((candidate) => _buildCandidateCard(
            candidate: candidate,
            itemWidth: itemWidth.clamp(280, 380),
            constraints: constraints,
          )).toList(),
        );
      },
    );
  }

  /// This method calculates the number of columns based on the screen width
  Widget _buildCandidateCard({
    required Candidate candidate,
    required double itemWidth,
    required BoxConstraints constraints,
  }) {
    final bool isMobile = constraints.maxWidth <= 600;

    return Container(
      width: itemWidth,
      height: 450, // Fixed height for all cards
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF242F40),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: isMobile ? 80 : 100,
            backgroundImage: AssetImage(candidate.imagePath),
            backgroundColor: const Color(0xFFE5E5E5),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              candidate.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              candidate.partyName,
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 16 : 18,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _showManifestoDialog(constraints, candidate),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCCA43B),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'View Manifesto',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// This method shows the manifesto dialog
  void _showManifestoDialog(BoxConstraints constraints, Candidate candidate) {
    _logger.i('Opening manifesto dialog for candidate: ${candidate.name}');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth * 0.8,
              maxHeight: constraints.maxHeight * 0.8,
            ),
            child: ManifestoDialog(
              candidate: candidate,
            ),
          ),
        );
      },
    );
  }

  /// This method disposes the candidate service
  @override
  void dispose() {
    _candidateService.dispose();
    super.dispose();
  }
}