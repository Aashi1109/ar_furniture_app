import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/product.dart';

/// It holds all the methods to add, delete and update products data in
/// firestore. products data is store in `[products]` collection node.
/// No error handling is done is here it should be handled where you are using
/// it.
class ProductHelper {
  static const productsCollectionPath = 'products';

  /// Returns products collection. Doesn't depend on current user.
  static CollectionReference<Map<String, dynamic>> getProductsCollection() {
    final productsCollection =
        FirebaseFirestore.instance.collection(productsCollectionPath);

    return productsCollection;
  }

  /// Removes product with `productId` from `products` collection
  static Future<void> removeProductFromFirestore(String productId) async {
    final productsCollection = getProductsCollection();
    // final query =
    //     await productsCollection.where('id', isEqualTo: productId).get();
    await productsCollection.doc(productId).delete();
  }

  /// Adds new product in firestore's `products` collection
  static Future<void> addProductInFirestore(
    Map<String, Object> product, {
    String? productId,
  }) async {
    final productsCollection = getProductsCollection();
    await productsCollection
        .doc(
      productId,
    )
        .set({
      'title': product['title'],
      'price': product['price'],
      'description': product['description'],
      'images': product['imagesFor'],
      'vector': product['vector'],
      'modelUrl': product['modelUrl'],
      'category': product['category'],
      if (productId == null) 'createdAt': Timestamp.now(),
    });
  }
}
