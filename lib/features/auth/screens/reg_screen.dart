import 'package:election_platform/shared/widgets/main_navigator.dart';
import 'package:flutter/material.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({super.key});

  @override
  State<RegScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: MainNavigator(),
      body: Center(
        child: Text('This is the registration screen'),
      ),
    );
  }
}
