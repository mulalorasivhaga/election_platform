import 'package:flutter/material.dart';

/// This is the state class for the ManifestoDialog widget
class ManifestoDialog extends StatefulWidget {
  final String candidateName;
  final String candidateParty;
  final String manifesto;

  /// This is the constructor for the ManifestoDialog widget
  const ManifestoDialog({
    super.key,
    required this.candidateName,
    required this.candidateParty,
    required this.manifesto,
  });

  /// This method creates the state for the ManifestoDialog widget
  @override
  State<ManifestoDialog> createState() => _ManifestoDialogState();
}
/// This is the state class for the ManifestoDialog widget
class _ManifestoDialogState extends State<ManifestoDialog> {

/// This method builds the ManifestoDialog widget
  String candidateName = 'Candidate Name';
  String candidateParty = 'Party Name';
  String manifesto = 'This is the manifesto of the candidate';

  /// This method builds the ManifestoDialog widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF242F40),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header section
            _buildHeader(),
            const SizedBox(height: 20),
            // Main login container
            _buildManifestoContainer(),
          ],
        ),
      ),
    );
  }


  /// This method builds the header section of the ManifestoDialog widget
  Widget _buildHeader() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Text(
            candidateName,
            style: const TextStyle(
              color: Color(0xFFCCA43B),
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          candidateParty,
          style: const TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// This method builds the manifesto container of the ManifestoDialog widget
  Widget _buildManifestoContainer() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Divider(
              color: Color(0xFFCCA43B),
              thickness: 2,
            ),
            const SizedBox(height: 20),
            Text(
              manifesto,
              style: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
