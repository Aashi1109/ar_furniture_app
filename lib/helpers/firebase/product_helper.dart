import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/product.dart';

class ProductHelper {
  static const productsCollectionPath = 'products';
  static CollectionReference<Map<String, dynamic>> getProductsCollection() {
    final productsCollection =
        FirebaseFirestore.instance.collection(productsCollectionPath);

    return productsCollection;
  }

  static Future<void> removeProductFromFirestore(String productId) async {
    final productsCollection = getProductsCollection();
    final query =
        await productsCollection.where('id', isEqualTo: productId).get();
    await productsCollection.doc(productId).delete();
  }

  static Future<void> addProductInFirestore(ProductItemModel product) async {
    final productsCollection = getProductsCollection();
    await productsCollection.add({
      'title': product.title,
      'price': product.price,
      'description': product.description,
      'images': product.images,
      'vector': product.vector,
      'modelUrl': product.modelUrl,
      'categories': product.categories,
      // 'isFavourite': product.isFavourite,
      'createdAt': Timestamp.now(),
    });
  }
}
