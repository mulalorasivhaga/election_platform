import 'package:logger/logger.dart';
import '../../../config/routes.dart';
import '../widgets/profile_view_dialog.dart';
import 'package:election_platform/shared/widgets/user_navigator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth/models/user.dart' as auth;
import '../widgets/voting_dialog.dart';


class UserDashboard extends StatelessWidget {
  // Logger instance
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
    ),
  );
  UserDashboard({super.key});

  /// Get the current user from Firestore
  Future<auth.User?> _getCurrentUser() async {
    try {
      _logger.i('🔍 Fetching current user...');
      final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        _logger.w('⚠️ No authenticated user found');
        return null;
      }

      _logger.d('📱 Fetching user document for UID: ${firebaseUser.uid}');
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!userDoc.exists) {
        _logger.w('⚠️ User document not found in Firestore');
        return null;
      }

      _logger.i('✅ User data retrieved successfully');
      return auth.User.fromMap(userDoc.data()!);
    } catch (e) {
      _logger.e('❌ Error fetching user data: $e');
      return null;
    }
  }

  /// Show the voting dialog
  void _showVotingDialog(BuildContext context) async {
    final currentUser = await _getCurrentUser();
    if (currentUser != null && context.mounted) {
      _showDialog(context, VotingDialog(currentUser: currentUser));
    } else if (context.mounted) {
      Navigator.pushNamed(context, '/login');
    }
  }

  /// function to show the profile dialog
  void _showProfileDialog(BuildContext context) async {
    try {
      _logger.i('🔄 Opening profile view dialog...');
      final currentUser = await _getCurrentUser();

      if (currentUser != null && context.mounted) {
        _logger.i('👤 Showing profile for user: ${currentUser.idNumber}');
        _showDialog(context, ProfileViewDialog(currentUser: currentUser));
      } else if (context.mounted) {
        _logger.w('⚠️ User not authenticated, redirecting to login');
        Navigator.pushNamed(context, '/login');
      }
    } catch (e) {
      _logger.e('❌ Error showing profile dialog: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load profile')),
        );
      }
    }
  }

/// function to show customized dialog box
  void _showDialog(BuildContext context, Widget dialogContent) {
    showDialog(
      context: context,
      barrierDismissible: false,
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
          child: dialogContent,
        ),
      ),
    );
  }


  /// Build the user dashboard
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UserNavigator(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
        child: Center(
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 24.0,
              mainAxisSpacing: 24.0,
              childAspectRatio: 1.5, // Adjust this value to control card height
              mainAxisExtent: 300, // Fixed height for each card
            ),
            children: [
              _buildCard(
                title: 'View\nProfile',
                onTap: () => _showProfileDialog(context),
                color: const Color(0xFF242F40),
              ),
              _buildCard(
                title: 'View\nResults',
                onTap: ()  => Navigator.pushNamed(context, Routes.results),
                color: const Color(0xFF242F40),
              ),
              _buildCard(
                title: 'Vote',
                onTap: () => _showVotingDialog(context),
                color: const Color(0xFFCCA43B),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the card widget
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