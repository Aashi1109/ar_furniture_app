import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase_helper.dart';

/// It holds all the methods to add, delete and update screenshots data in
/// firestore. screenshots data is store in userDoc having id as
/// `[screenshots]`.
/// The Structure of how screenshots's data is stored in firestore
/// `[users > userId > screenshots > screenshotsData]`.
///
/// Uploads screenshots to `screenshotsStoragePath`.
/// No error handling is done is here it should be handled where you are using
/// it.
class ScreenshotHelper {
  static const screenshotCollectionPath = 'screenshots';
  static const screenshotStoragePath = 'screenshots';

  /// Returns current user's screenshots collection.
  static CollectionReference<Map<String, dynamic>> getUserSsCollection() {
    return FirebaseHelper.getUserDoc().collection(screenshotCollectionPath);
  }

  /// Save screenshots data to screeshots collection. `data` contains key
  /// [imageUrl]and [productId].
  static Future<void> saveSsToFirestore(Map<String, dynamic> data) async {
    await getUserSsCollection().add(data);
  }

  /// Returns screenshots data for current user.
  static Future<QuerySnapshot<Map<String, dynamic>>>
      getSsFromFirestore() async {
    return getUserSsCollection().get();
  }

  /// Delete a screenshot using [ssId].
  static Future<void> deleteSsFromFirestore(String ssId) {
    return getUserSsCollection().doc(ssId).delete();
  }
}
