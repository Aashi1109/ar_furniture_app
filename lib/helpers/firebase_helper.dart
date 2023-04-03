import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseHelper {
  static const usersCollectionPath = 'users';

  static DocumentReference<Map<String, dynamic>> getUserDoc({String? uid}) {
    uid ??= FirebaseAuth.instance.currentUser?.uid;
    return FirebaseFirestore.instance.collection(usersCollectionPath).doc(uid);
  }

  static Future<void> clearCollection(
      CollectionReference<Map<String, dynamic>> collection) async {
    QuerySnapshot querySnapshot = await collection.get();
    List<QueryDocumentSnapshot> docs = querySnapshot.docs;

    for (var doc in docs) {
      await doc.reference.delete();
    }
  }
}
