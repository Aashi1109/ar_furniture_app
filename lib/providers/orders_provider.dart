import '../constants.dart';
import '../helpers/general_helper.dart';
import 'notification_provider.dart';

import '../helpers/firebase/order_helper.dart';

import '../models/cart.dart';
import '../models/order.dart';
import 'package:flutter/material.dart';

class OrderProviderModel with ChangeNotifier {
  // NotificationProviderModel? notificationProvider;

  // OrderProviderModel({this.notificationProvider});

  NotificationProviderModel? _notificationProvider;
  bool _isOrderDataInit = true;

  set notificationProvider(NotificationProviderModel notificationProvider) {
    _notificationProvider = notificationProvider;
  }

  List<OrderItemModel> _orders = [];
  // bool _wasOrderEmpty = true;
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
    if (_orders.isNotEmpty) {
      _notificationProvider?.addNotification(
        NotificationItemModel(
            text: orderNotifications['t1']!['text']!,
            id: DateTime.now().toString(),
            title: orderNotifications['t1']!['title']!,
            icon: Icons.shopping_bag,
            action: {
              'action': 'order',
              'params': '',
            }),
        isNew: true,
      );
    }
    // debugPrint('in order add');

    notifyListeners();
  }

  Future<void> pushOrdersToFirebase() async {
    try {
      await OrderHelper.addOrderInFirestore(_orders[0]);
    } catch (error) {
      debugPrint(
          'error in storing order data to firestore ${error.toString()}');
    }
  }

  Future<void> getAndSetOrdersData() async {
    return GeneralHelper.getAndSetWrapper(_isOrderDataInit, () async {
      final orders = await OrderHelper.getOrdersFromFirestore();
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
    });
    // try {
    //   final orders = await OrderHelper.getOrdersFromFirestore();
    //   // debugPrint(orders[0].toString());
    //   final loadedOrders = List<OrderItemModel>.from(
    //     orders
    //         .map(
    //           (e) => OrderItemModel(
    //             id: e.id,
    //             amount: e['amount'],
    //             placedAt: e['placedAt'].toDate(),
    //             products: List<CartItemModel>.from(
    //               (e['products'])
    //                   .map((e) => CartItemModel(
    //                         id: e['id'],
    //                         title: e['title'],
    //                         price: e['price'],
    //                         quantity: e['quantity'],
    //                         imageUrl: e['imageUrl'],
    //                       ))
    //                   .toList(),
    //             ),
    //           ),
    //         )
    //         .toList(),
    //   );

    //   _orders = loadedOrders;
    //   notifyListeners();
    //   } catch (error) {
    //     debugPrint(
    //         'error in fetching order data from firestore ${error.toString()}');
    //     debugPrintStack();
    //   }
  }
}
