import 'package:election_platform/shared/widgets/main_navigator.dart';
import 'package:flutter/material.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MainNavigator(),
      body: Center(
        child: Text('This is the view results screen'),
      ),
    );
  }
}
