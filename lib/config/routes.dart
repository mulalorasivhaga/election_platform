import 'package:election_platform/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/reg_screen.dart';
import '../features/results/screens/results_screen.dart';
import '../features/user_dashboard/screens/user_dashboard.dart';


class Routes {
  // Define route names as constants
  static const String initial = '/home';  // initial route
  static const String login = '/login';
  static const String register = '/register';
  static const String results = '/results';
  static const String users = '/users';

  // Define route generation
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      initial: (context) => const HomeScreen(),  // initial screen
      login: (context) => const LoginScreen(),
      register: (context) => const RegScreen(),
      results: (context) => ElectionResultsScreen(),
      users: (context) => const UserDashboard(),
    };
  }
}