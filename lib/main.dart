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
          apiKey: "API_KEY",
          authDomain: "AUTH_DOMAIN",
          projectId: "PROJECT_ID",
          storageBucket: "STORAGE_BUCKET",
          messagingSenderId: "MS_ID",
          appId: "APP_ID",
          measurementId: "MEASUREMENT_ID"
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
