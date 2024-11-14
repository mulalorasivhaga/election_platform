//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:election_platform/features/home/screens/home_screen.dart';
import 'package:election_platform/config/routes.dart';

Future <void> main() async {

  // Initialize Firebase
  //await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Election Platform',
      routes: Routes.getRoutes(),
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(), // HomeScreen is the first screen that will be displayed;
    );
  }
}

