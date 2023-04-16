import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase_helper.dart';

/// It holds all the methods to add, delete and update settings data in
/// firestore. settings data is store in userDoc having id as
/// `[settings]`.
/// The Structure of how settings's data is stored in firestore
/// `[users > userId > settings > settings > settingsData]`.
/// No error handling is done is here it should be handled where you are using
/// it.
class SettingHelper {
  static const settingsCollectionPath = 'settings';

  /// Returns current user's settings collection.
  static CollectionReference<Map<String, dynamic>> getUserSettingsCollection() {
    return FirebaseHelper.getUserDoc().collection(settingsCollectionPath);
  }

  /// Returns current user's settings data.
  static DocumentReference<Map<String, dynamic>> getSettingsFromFirestore() {
    return getUserSettingsCollection().doc(settingsCollectionPath);
  }

  /// Updates settings in settings collection. It doesn't override instead
  /// merge it with previous one.
  static setSettingsInFirestore(settingsToUpdate) {
    return getUserSettingsCollection().doc(settingsCollectionPath).set(
          settingsToUpdate,
          SetOptions(
            merge: true,
          ),
        );
  }
}
