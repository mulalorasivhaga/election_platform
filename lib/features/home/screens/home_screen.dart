import 'package:election_platform/shared/widgets/main_navigator.dart';
import 'package:flutter/material.dart';

import '../widgets/manifesto_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //candidate details
  String candidateName = 'Candidate Name';
  String candidateParty = 'Party Name';
  String manifestoButton = 'View Manifesto';
  String candidateImage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFE5E5E5),
        appBar: const MainNavigator(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              /// Header section
              _buildHeader(),
              const SizedBox(height: 50),

              /// Candidate details section
              /// Display three candidate details
              /// Each candidate detail contains the candidate image, name, party, and a button to view their manifesto
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCandidateDetails(),
                      _buildCandidateDetails(),
                      _buildCandidateDetails(),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 70),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCandidateDetails(),
                      _buildCandidateDetails(),
                      _buildCandidateDetails(),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 70),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCandidateDetails(),
                      _buildCandidateDetails(),
                      _buildCandidateDetails(),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 70),
            ],
          ),
        ));
  }

// Helper method for header section
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 50),
      child: const Column(
        children: [
          Text(
            'Welcome to Election Platform',
            style: TextStyle(
              color: Color(0xFFCCA43B),
              fontSize: 72,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 250.0),
            child: Text(
              "Your trusted platform for secure and confidential voting in South Africa. Vote for your preferred candidate and party to shape the future of our country. Your vote is your voice, and we ensure your voice is heard.",
              style: TextStyle(
                color: Color(0xFF242F40),
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

// Helper method for candidate details section
  Widget _buildCandidateDetails() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
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
        width: 300,
        child: Column(
          children: [
            // Candidate image
            CircleAvatar(
              radius: 100,
              backgroundImage: candidateImage.isNotEmpty ? NetworkImage(candidateImage) : null,
              backgroundColor: const Color(0xFFE5E5E5),
              foregroundColor: const Color(0xFF242F40),
              child: candidateImage.isEmpty ? const Icon(Icons.person, size: 80) : null,
            ),
            const SizedBox(height: 20),
            // Candidate name
            Text(
              candidateName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Candidate party
            Text(
              candidateParty,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            // Candidate manifesto
            ElevatedButton(
              onPressed: () {
                // Navigate to candidate manifesto dialog where their full manifesto is displayed
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      insetPadding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: const ManifestoDialog(),
                      ),
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCCA43B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                manifestoButton,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
