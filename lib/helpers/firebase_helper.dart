import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:decal/models/order.dart';
import 'package:decal/models/product.dart';

class FirebaseHelper {
  // static final userId = FirebaseAuth.instance.currentUser?.uid;
  static const productsCollectionPath = 'products';
  static const usersCollectionPath = 'users';
  static const ordersCollectionPath = 'orders';
  static const cartCollectionPath = 'cart';
  static const favouritesCollectionPath = 'favourites';
  static const userProfileImagesPath = 'profileImages';
  static const userProfileDataPath = 'profileData';
  static const reviewsCollectionPath = 'reviews';

  // Products collection getters
  static CollectionReference<Map<String, dynamic>> getProductsCollection() {
    final productsCollection =
        FirebaseFirestore.instance.collection(productsCollectionPath);

    return productsCollection;
  }

  // User collections getters
  static CollectionReference<Map<String, dynamic>> getUserCartCollection() {
    final userCartCollection = FirebaseFirestore.instance
        .collection(usersCollectionPath)
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection(cartCollectionPath);

    return userCartCollection;
  }

  static CollectionReference<Map<String, dynamic>>
      getUserFavouritesCollection() {
    final userFavouritesCollection = FirebaseFirestore.instance
        .collection(usersCollectionPath)
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection(favouritesCollectionPath);

    return userFavouritesCollection;
  }

  static CollectionReference<Map<String, dynamic>>
      getUserProfileImagesCollection() {
    final userProfileImagesCollection = FirebaseFirestore.instance
        .collection(usersCollectionPath)
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection(userProfileImagesPath);

    return userProfileImagesCollection;
  }

  static CollectionReference<Map<String, dynamic>> getUserProfileDataCollection(
      {String? userId}) {
    final userProfileImagesCollection = FirebaseFirestore.instance
        .collection(usersCollectionPath)
        .doc(userId ?? FirebaseAuth.instance.currentUser?.uid)
        .collection(userProfileDataPath);

    return userProfileImagesCollection;
  }

  static CollectionReference<Map<String, dynamic>> getUserOrdersCollection() {
    final userOrdersCollection = FirebaseFirestore.instance
        .collection(usersCollectionPath)
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection(ordersCollectionPath);

    return userOrdersCollection;
  }

  static CollectionReference<Map<String, dynamic>> getReviewsCollection() {
    final reviewsCollection =
        FirebaseFirestore.instance.collection(reviewsCollectionPath);

    return reviewsCollection;
  }

  // Methods to access data from firestore

  static getCartFromFirestore() async {
    final userCartCollection = getUserCartCollection();
    final query = await userCartCollection.get();
    return query.docs;
  }

  static Future<void> toggleFavouritesInFirestore(
      String prodId, bool isFavourite) async {
    final userFavouritesCollection = getUserFavouritesCollection();

    return userFavouritesCollection
        .doc(prodId)
        .set({'isFavourite': isFavourite});
  }

  static Future<void> setCartDataInFirestore(
      Map<String, dynamic> cartData) async {
    final userCartCollection = getUserCartCollection();
    // final cartItems = CartProviderModel.items;
    // final cartItemsMap = cartItems.map((e) => e.toMap()).toList();
    // final cartItemsJson = jsonEncode(cartItemsMap);
    return userCartCollection.doc('cart').set(cartData);
  }

  static Future<void> addOrderInFirestore(OrderItemModel order) async {
    final userOrdersCollection = getUserOrdersCollection();

    await userOrdersCollection.add({
      // 'id': order.id,
      'products': order.products
          .map((cartItem) => {
                'id': cartItem.id,
                'title': cartItem.title,
                'price': cartItem.price,
                'quantity': cartItem.quantity,
                'imageUrl': cartItem.imageUrl,
                'total': cartItem.total,
              })
          .toList(),
      'amount': order.amount,
      'placedAt': order.placedAt,
      // 'createdAt': Timestamp.now(),
    });
  }

  static getOrdersFromFirestore() async {
    final userOrdersCollection = getUserOrdersCollection();
    final query = await userOrdersCollection.get();
    return query.docs;
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>>
      getCartDataFromFirestore() {
    final userCartCollection = getUserCartCollection();
    return userCartCollection.doc('cart').get();
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

  static UploadTask uploadImage(File image, String imageName,
      {String uploadPath = userProfileImagesPath}) {
    final ref =
        FirebaseStorage.instance.ref().child(uploadPath).child(imageName);

    return ref.putFile(image);
  }

  static saveExtraUserDataInFirestore(
    Map<String, dynamic> data,
  ) {
    final userProfilesCollection = getUserProfileDataCollection();
    // print(userProfilesCollection.toString());
    return userProfilesCollection.doc('profileData').set(
        data,
        SetOptions(
          merge: true,
        ));
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>>
      getUserProfileDataFromFirestore({String? userId}) {
    final userProfileDataCollection = getUserProfileDataCollection(
      userId: userId,
    );
    return userProfileDataCollection.doc(userProfileDataPath).get();
  }

  static Future<void> addReviewsInFirestore(Map<String, dynamic> review) {
    final reviewsCollection = getReviewsCollection();
    return reviewsCollection.add(
      review,
    );
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getReviewsFromFirestore() {
    final reviewsCollection = getReviewsCollection();
    return reviewsCollection.get();
  }
}
