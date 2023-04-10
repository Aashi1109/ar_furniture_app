import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Contains some helpers methods related to firebase
class FirebaseHelper {
  static const usersCollectionPath = 'users';

  /// Returns used doc for current user. By giving `uid` doc for other used can be
  /// accessed.
  /// Data structure is `[users > userId ]`
  static DocumentReference<Map<String, dynamic>> getUserDoc({String? uid}) {
    uid ??= FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance.collection(usersCollectionPath).doc(uid);
  }

  /// Clears all data from a collection. Requires collection to delete.
  static Future<void> clearFirestoreCollection(
      CollectionReference<Map<String, dynamic>> collection) async {
    QuerySnapshot querySnapshot = await collection.get();
    List<QueryDocumentSnapshot> docs = querySnapshot.docs;
    List<Future> futures = [];
    for (var doc in docs) {
      futures.add(doc.reference.delete());
    }
    await Future.wait(futures);
  }

  static Future<void> sendVerificationMailToUser() async {
    return FirebaseAuth.instance.currentUser?.sendEmailVerification();
  }
}
