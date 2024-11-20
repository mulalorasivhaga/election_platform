import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:election_platform/shared/services/vote_service.dart';
import 'package:election_platform/shared/services/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Firebase providers
final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);
final authProvider = Provider((ref) => FirebaseAuth.instance);

// Service providers
final voteServiceProvider = Provider<VoteService>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final auth = ref.watch(authProvider);
  return VoteService(
    firestore: firestore,
    auth: auth,
  );
});

final authServiceProvider = Provider<AuthService>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final auth = ref.watch(authProvider);
  return AuthService(
    firestore: firestore,
    auth: auth,
  );
});