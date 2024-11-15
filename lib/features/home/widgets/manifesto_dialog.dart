import 'package:flutter/material.dart';

class ManifestoDialog extends StatefulWidget {
  const ManifestoDialog({super.key});

  @override
  State<ManifestoDialog> createState() => _ManifestoDialogState();
}

class _ManifestoDialogState extends State<ManifestoDialog> {

  String candidateName = 'Candidate Name';
  String candidateParty = 'Party Name';
  String manifesto = 'This is the manifesto of the candidate';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          candidateName,
          style: const TextStyle(
            color: Color(0xFFCCA43B),
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          candidateParty,
          style: const TextStyle(
            color: Color(0xFF242F40),
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildManifestoContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          Text(
            manifesto,
            style: const TextStyle(
              color: Color(0xFF242F40),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
