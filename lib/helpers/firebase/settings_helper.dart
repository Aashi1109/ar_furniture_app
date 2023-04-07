import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase_helper.dart';

class SettingHelper {
  static const settingsCollectionPath = 'settings';

  static CollectionReference<Map<String, dynamic>> getUserSettingsCollection() {
    return FirebaseHelper.getUserDoc().collection(settingsCollectionPath);
  }

  static DocumentReference<Map<String, dynamic>> getSettingsFromFirestore() {
    return getUserSettingsCollection().doc(settingsCollectionPath);
  }

  static setSettingsInFirestore(settingsToUpdate) {
    return getUserSettingsCollection().doc(settingsCollectionPath).set(
          settingsToUpdate,
          SetOptions(
            merge: true,
          ),
        );
  }
}
