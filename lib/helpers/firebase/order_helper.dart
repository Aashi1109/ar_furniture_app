import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/order.dart';
import '../firebase_helper.dart';

class OrderHelper {
  static const ordersCollectionPath = 'orders';

  static CollectionReference<Map<String, dynamic>> getUserOrdersCollection() {
    final userOrdersCollection =
        FirebaseHelper.getUserDoc().collection(ordersCollectionPath);

    return userOrdersCollection;
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
}
