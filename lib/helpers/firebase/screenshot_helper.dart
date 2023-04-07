import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_helper.dart';

class ScreenshotHelper {
  static const screenshotCollectionPath = 'screenshots';
  static const screenshotStoragePath = 'screenshots';

  static CollectionReference<Map<String, dynamic>> getUserSsCollection() {
    return FirebaseHelper.getUserDoc().collection(screenshotCollectionPath);
  }

  static Future<void> saveSsToFirestore(Map<String, dynamic> data) async {
    await getUserSsCollection().add(data);
  }

  static Future<QuerySnapshot<Map<String, dynamic>>>
      getSsFromFirestore() async {
    return getUserSsCollection().get();
  }

  static Future<void> deleteSsFromFirestore(String ssId) {
    return getUserSsCollection().doc(ssId).delete();
  }
}
