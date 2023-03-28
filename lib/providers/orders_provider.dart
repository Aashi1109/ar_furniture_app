import 'package:decal/helpers/firebase_helper.dart';
import 'package:decal/models/cart.dart';
import 'package:decal/models/order.dart';
import 'package:flutter/material.dart';

class OrderProviderModel with ChangeNotifier {
  List<OrderItemModel> _orders = [];

  List<OrderItemModel> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItemModel> cartProducts, double total) {
    _orders.insert(
      0,
      OrderItemModel(
        id: DateTime.now().toString(),
        amount: total,
        products: cartProducts,
        placedAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  Future<void> pushOrdersToFirebase() async {
    try {
      await FirebaseHelper.addOrderInFirestore(_orders[0]);
    } catch (error) {
      debugPrint(
          'error in storing order data to firestore ${error.toString()}');
    }
  }

  Future<void> getAndSetOrdersData() async {
    try {
      final orders = await FirebaseHelper.getOrdersFromFirestore();
      // debugPrint(orders[0].toString());
      final loadedOrders = List<OrderItemModel>.from(
        orders
            .map(
              (e) => OrderItemModel(
                id: e.id,
                amount: e['amount'],
                placedAt: e['placedAt'].toDate(),
                products: List<CartItemModel>.from(
                  (e['products'])
                      .map((e) => CartItemModel(
                            id: e['id'],
                            title: e['title'],
                            price: e['price'],
                            quantity: e['quantity'],
                            imageUrl: e['imageUrl'],
                          ))
                      .toList(),
                ),
              ),
            )
            .toList(),
      );

      _orders = loadedOrders;
      notifyListeners();
    } catch (error) {
      debugPrint(
          'error in fetching order data from firestore ${error.toString()}');
      debugPrintStack();
    }
  }
}
