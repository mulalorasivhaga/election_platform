import 'package:cloud_firestore/cloud_firestore.dart';


class FirebaseConfig {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
//initialize firestore
  static Future<void> initializeFirestore () async {
    //enable offline persistence
    //Set cache size to unlimited
    firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }
}