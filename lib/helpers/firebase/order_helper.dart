import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/order.dart';
import '../firebase_helper.dart';

/// It holds all the methods to add, delete and update order data in
/// firestore. order data is store in userDoc having id as
/// `[orders]`.
/// The Structure of how order's data is stored in firestore
/// `[users > userId > orders > orderData]`.
/// No error handling is done is here it should be handled where you are using
/// it.
class OrderHelper {
  static const ordersCollectionPath = 'orders';

  /// Returns current user's order collection
  static CollectionReference<Map<String, dynamic>> getUserOrdersCollection() {
    final userOrdersCollection =
        FirebaseHelper.getUserDoc().collection(ordersCollectionPath);

    return userOrdersCollection;
  }

  /// Add order in current user's order collection
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

  /// Returns orders data for current user.
  static getOrdersFromFirestore() async {
    final userOrdersCollection = getUserOrdersCollection();
    final query = await userOrdersCollection.get();
    return query.docs;
  }
}
