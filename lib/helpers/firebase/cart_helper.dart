import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartHelper {
  static const cartCollectionPath = 'cart';
  static const usersCollectionPath = 'users';

  static CollectionReference<Map<String, dynamic>> getUserCartCollection() {
    final userCartCollection =
        FirebaseHelper.getUserDoc().collection(cartCollectionPath);

    return userCartCollection;
  }

  static getCartFromFirestore() async {
    final userCartCollection = getUserCartCollection();
    final query = await userCartCollection.get();
    return query.docs;
  }

  static Future<void> setCartDataInFirestore(
      Map<String, dynamic> cartData) async {
    final userCartCollection = getUserCartCollection();

    return userCartCollection.doc('cart').set(cartData);
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>>
      getCartDataFromFirestore() {
    final userCartCollection = getUserCartCollection();
    return userCartCollection.doc('cart').get();
  }
}
