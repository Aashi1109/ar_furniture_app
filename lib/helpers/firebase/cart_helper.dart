import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_helper.dart';

/// It holds all the methods to add, delete and update cart data in firestore
/// cart data is store in userDoc having id as [cart].
/// The Structure of how cart's data is stored in firestore
/// `[users > userId > cart > cart > cartData]`.
/// No error handling is done here it should be handled where you are using it.
class CartHelper {
  static const cartCollectionPath = 'cart';
  // static const usersCollectionPath = 'users';
  /// Returns cart collection for the current user.

  static CollectionReference<Map<String, dynamic>> getUserCartCollection() {
    final userCartCollection =
        FirebaseHelper.getUserDoc().collection(cartCollectionPath);

    return userCartCollection;
  }

  /// It saves cart data in firestore in subcollection under doc having id
  /// cart. It overwrites all the previous data
  /// [cartData] is map which contains key [isOrdered] and [items]
  static Future<void> setCartDataInFirestore(
      Map<String, dynamic> cartData) async {
    final userCartCollection = getUserCartCollection();

    return userCartCollection.doc('cart').set(cartData);
  }

  /// Returns cart data stored in firestore
  static Future<DocumentSnapshot<Map<String, dynamic>>>
      getCartDataFromFirestore() {
    final userCartCollection = getUserCartCollection();
    return userCartCollection.doc('cart').get();
  }
}
