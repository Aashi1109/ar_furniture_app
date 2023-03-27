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
}
