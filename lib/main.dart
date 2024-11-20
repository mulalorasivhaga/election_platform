import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:election_platform/features/home/screens/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/routes.dart';


Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    // Initialize Firebase first
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDahoPIX8g2FSRfDb73uxgbmlzPI9viMCw",
          authDomain: "election-platform-52367.firebaseapp.com",
          projectId: "election-platform-52367",
          storageBucket: "election-platform-52367.firebaseapp.com",
          messagingSenderId: "719698721001",
          appId: "1:719698721001:web:046b4df3c52baeae2f9878",
          measurementId: "G-1Y2JFVL8FL"
      ),
    );




    runApp(const ProviderScope (
        child: MyApp()
        )
    );
  } catch (e) {
    debugPrint('Initialization error: $e');
    runApp(const MaterialApp(home: Center(child: CircularProgressIndicator())));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Election Platform',
      debugShowCheckedModeBanner: false,
      routes: Routes.getRoutes(),
      theme: ThemeData(
        primaryColor: const Color(0xFFCCA43B),
        scaffoldBackgroundColor: const Color(0xFFE5E5E5),
      ),
      home:  const HomeScreen(), //change to home screen when completed with User Dashboard
    );
  }
}