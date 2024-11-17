import 'package:election_platform/shared/widgets/user_navigator.dart';
import 'package:flutter/material.dart';

import '../widgets/voting_dialog.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  String get title => 'User Dashboard';

  void _showVotingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: const Color(0xFF242F40),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const VotingDialog(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UserNavigator(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100.0, horizontal: 24.0),
        child: Center(
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            children: [
              _buildCard(
                title: 'View\nProfile',
                onTap: () {
                  //Dialog to view user profile details
                },
                color: const Color(0xFF242F40),
              ),
              _buildCard(
                title: 'Edit\nProfile',
                onTap: () {
                  //Dialog to enable user edit profile
                },
                color: const Color(0xFF242F40),
                isDisabled: true,
              ),
              _buildCard(
                title: 'Your\nVote',
                onTap: () {
                  //Dialog to show users vote
                },
                color: const Color(0xFF242F40),
              ),
              _buildCard(
                title: 'Vote',
                onTap: () => _showVotingDialog(context), // Show voting dialog
                color: const Color(0xFFCCA43B),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required VoidCallback onTap,
    required Color color,
    bool isDisabled = false,
  }) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.8),
                color,
              ],
            ),
          ),
          child: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
        ),
      ),
    );
  }
}