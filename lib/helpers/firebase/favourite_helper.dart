import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase_helper.dart';

// It holds methods to add and update favourites data in firestore
/// favourites data is stored in userDoc having id as [favourites].
/// The Structure of how favourites's data is stored in firestore
/// `[users > userId > favourites > productId > {isFavourite: ...}]`.
/// No error handling is done here it should be handled where you are using
/// it.
class FavouriteHelper {
  static const favouritesCollectionPath = 'favourites';

  /// Returns current user favourites collection.
  static CollectionReference<Map<String, dynamic>>
      getUserFavouritesCollection() {
    final userFavouritesCollection =
        FirebaseHelper.getUserDoc().collection(favouritesCollectionPath);

    return userFavouritesCollection;
  }

  /// Creates new doc with favourite value as [isFavourite] and is
  /// overridden everytime
  /// [prodId] is id of product for which you have to set favourite.
  static Future<void> toggleFavouritesInFirestore(
      String prodId, bool isFavourite) async {
    final userFavouritesCollection = getUserFavouritesCollection();

    return userFavouritesCollection
        .doc(prodId)
        .set({'isFavourite': isFavourite});
  }
}
