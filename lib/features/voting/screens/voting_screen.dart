import 'package:election_platform/shared/widgets/main_navigator.dart';
import 'package:flutter/material.dart';

class VotingScreen extends StatefulWidget {
  const VotingScreen({super.key});

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MainNavigator(),
      body: Center(
        child: Text('This is the voting screen'),
      ),
    );
  }
}
