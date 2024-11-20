// lib/providers/user_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:election_platform/shared/providers/service_providers.dart';
import 'package:election_platform/features/auth/models/user_model.dart' as auth;

final userProvider = FutureProvider<auth.User?>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return await authService.getCurrentUser();
});