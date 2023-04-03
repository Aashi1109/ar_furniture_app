import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavouriteHelper {
  static const favouritesCollectionPath = 'favourites';
  static CollectionReference<Map<String, dynamic>>
      getUserFavouritesCollection() {
    final userFavouritesCollection =
        FirebaseHelper.getUserDoc().collection(favouritesCollectionPath);

    return userFavouritesCollection;
  }

  static Future<void> toggleFavouritesInFirestore(
      String prodId, bool isFavourite) async {
    final userFavouritesCollection = getUserFavouritesCollection();

    return userFavouritesCollection
        .doc(prodId)
        .set({'isFavourite': isFavourite});
  }
}
