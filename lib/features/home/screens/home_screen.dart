import 'package:election_platform/shared/widgets/main_navigator.dart';
import 'package:flutter/material.dart';
import '../widgets/manifesto_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
/// This is the state class for the HomeScreen widget
class _HomeScreenState extends State<HomeScreen> {
  String candidateName = 'Candidate Name'; // Candidate name
  String candidateParty = 'Party Name'; // Candidate party
  String manifestoButton = 'View Manifesto'; // Manifesto button
  String candidateImage = ''; // Candidate image

  /// This method builds the HomeScreen widget
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

  /// This method builds the header section of the HomeScreen widget
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

/// This method builds the candidate grid section of the HomeScreen widget
  Widget _buildCandidateGrid(BoxConstraints constraints) {
    final crossAxisCount = _getCrossAxisCount(constraints.maxWidth);
    final itemWidth = (constraints.maxWidth - (32.0 * (crossAxisCount - 1))) / crossAxisCount;
/// Return the candidate grid
    return Wrap(
      spacing: 32,
      runSpacing: 32,
      children: List.generate(
        9,
            (index) => _buildCandidateCard(
          itemWidth: itemWidth.clamp(280, 380),
          constraints: constraints,
        ),
      ),
    );
  }

  /// This method returns the cross axis count based on the screen width
  int _getCrossAxisCount(double width) {
    if (width > 1200) return 3;
    if (width > 800) return 3;
    return 1;
  }

  /// This method builds the candidate card
  Widget _buildCandidateCard({
    required double itemWidth,
    required BoxConstraints constraints,
  }) {
    final bool isMobile = constraints.maxWidth <= 600;
/// Return the candidate card
    return Container(
      width: itemWidth,
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
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: isMobile ? 80 : 100,
            backgroundColor: const Color(0xFFE5E5E5),
            child: const Icon(Icons.person, size: 80),
          ),
          const SizedBox(height: 16),
          Text(
            candidateName,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            candidateParty,
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 16 : 18,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _showManifestoDialog(constraints),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCCA43B),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            child: const Text(
              'View Manifesto',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// This method shows the manifesto dialog
  void _showManifestoDialog(BoxConstraints constraints) {
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
              candidateName: candidateName,
              candidateParty: candidateParty,
              manifesto: '',
            ),
          ),
        );
      },
    );
  }
}
