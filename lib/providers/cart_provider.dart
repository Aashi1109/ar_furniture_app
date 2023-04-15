import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../helpers/general_helper.dart';
import 'notification_provider.dart';
import '../helpers/firebase/cart_helper.dart';
import '../models/cart.dart';


/// It provides data for Cart and expose methods to access or change
/// this data.
class CartProviderModel with ChangeNotifier {
  NotificationProviderModel? _notificationProvider;

  set notificationProvider(NotificationProviderModel notificationProvider) {
    _notificationProvider = notificationProvider;
  }

  // CartProviderModel({this.notificationProvider});
  // This is used while saving our cart to check whether the recent cart data
  //is ordered or not. Also we show cart dart which is not ordered.
  bool _isOrdered = false;
  List<CartItemModel> _items = [];
  // This will be used to generate notification message when new cart data is created.
  bool _wasCartEmpty = true;
  bool _isDataInit = true; // Used to initalize data for first time.

  List<CartItemModel> get items {
    if (!_isOrdered) {
      return [..._items];
    }
    return [];
  }

  /// This method adds item to cart or increase its quantity when present.
  /// Also generate notification when cart is not ordered.
  void addItemToCart({
    required String prodId,
    required String title,
    required double price,
    required int quantity,
    required String imageUrl,
  }) {
    // debugPrint(_items.length.toString());
    final existingCartitemIndex =
        _items.indexWhere((element) => element.id == prodId);

    if (existingCartitemIndex >= 0) {
      final existingCartitem = _items[existingCartitemIndex];
      final modifiedCartItem = CartItemModel(
        id: prodId,
        title: title,
        quantity: (quantity + existingCartitem.quantity).toInt(),
        price: price,
        imageUrl: imageUrl,
      );
      debugPrint('in update item');
      _items[existingCartitemIndex] = modifiedCartItem;
    } else {
      final newCartItem = CartItemModel(
        id: prodId,
        title: title,
        quantity: quantity,
        price: price,
        imageUrl: imageUrl,
      );
      // debugPrint('in update item new');
      _items.add(newCartItem);
      if (_items.isNotEmpty && _wasCartEmpty) {
        _notificationProvider?.addNotification(
          NotificationItemModel(
            text: cartNotifications['t1']!['text']!,
            id: DateTime.now().toString(),
            title: cartNotifications['t1']!['title']!,
            icon: Icons.shopping_cart_rounded,
            action: {
              'action': 'cart',
              'params': '',
            },
          ),
        );
      }
    }

    notifyListeners();
    _wasCartEmpty = _items.isEmpty;
  }

  /// Decreases quantity of items by 1 by default can be changed by setting
  /// `removeQuantity`. If `removeQuantity` is greater than item quantity,
  ///  `quantity` will
  /// only be decreased by one.
  void removeItemFromCart({
    required String prodId,
    int removeQuantity = 1,
  }) {
    // _items.remove(item);
    final existingCartitemIndex =
        _items.indexWhere((element) => element.id == prodId);

    if (existingCartitemIndex >= 0) {
      final existingCartitem = _items[existingCartitemIndex];
      final removeQuant =
          removeQuantity < existingCartitem.quantity ? removeQuantity : 1;

      final modifiedCartItem = CartItemModel(
        id: prodId,
        title: existingCartitem.title,
        quantity: existingCartitem.quantity - removeQuant,
        price: existingCartitem.price,
        imageUrl: existingCartitem.imageUrl,
      );
      debugPrint('in remove item');
      _items[existingCartitemIndex] = modifiedCartItem;
    }
    notifyListeners();
  }

  /// Clears all the cart data
  void clearCart() {
    _items.clear();
    _wasCartEmpty = true;
    notifyListeners();
  }

  /// Push data to firestore
  /// `isSave = true` ensures that our cart data only saves because it is not
  /// ordered and can be fetched when user wants it. When it is `false`
  /// that means order is placed and cartData should be cleared for next cart.
  Future<void> pushCartDataToFirestore({bool isSave = true}) async {
    // debugPrint('in cart push');
    try {
      await CartHelper.setCartDataInFirestore({
        'items': _items.map((cartItem) => {
              'id': cartItem.id,
              'title': cartItem.title,
              'price': cartItem.price,
              'quantity': cartItem.quantity,
              'total': cartItem.total,
              'imageUrl': cartItem.imageUrl,
              'createdAt': Timestamp.now(),
            }),
        'isOrdered': isSave ? false : _isOrdered,
      });
      if (!isSave) {
        clearCart();
      }
    } catch (error) {
      debugPrint('error in storing cart data to firestore ${error.toString()}');
    }
  }

  /// Fetch cart data and set only unordered ones.
  Future<void> getAndSetCartData() async {
    return GeneralHelper.getAndSetWrapper(
      _isDataInit,
      () async {
        final cartData = await CartHelper.getCartDataFromFirestore();
        if (!cartData.exists) {
          return;
        }
        final List<CartItemModel> cartItems = [];
        cartData['items'].forEach((cartItem) {
          // debugPrint('cartItem ${cartItem.toString()}');
          cartItems.add(CartItemModel(
            id: cartItem['id'],
            title: cartItem['title'],
            price: cartItem['price'],
            quantity: cartItem['quantity'],
            imageUrl: cartItem['imageUrl'],
          ));
        });
        _items = cartItems;
        _isOrdered = cartData['isOrdered'] ?? false;
        _isDataInit = false;
        notifyListeners();
      },
    );
    // try {
    //   final cartData = await CartHelper.getCartDataFromFirestore();
    //   if (cartData == null) {
    //     return;
    //   }
    //   final List<CartItemModel> cartItems = [];
    //   cartData['items'].forEach((cartItem) {
    //     // debugPrint('cartItem ${cartItem.toString()}');
    //     cartItems.add(CartItemModel(
    //       id: cartItem['id'],
    //       title: cartItem['title'],
    //       price: cartItem['price'],
    //       quantity: cartItem['quantity'],
    //       imageUrl: cartItem['imageUrl'],
    //     ));
    //   });
    //   _items = cartItems;
    //   _isOrdered = cartData['isOrdered'] ?? false;
    //   notifyListeners();
    // } catch (error) {
    //   debugPrint(
    //       'error in getting cart data from firestore ${error.toString()}');
    // }
  }

  double get totalCartPrice {
    return _items.fold(
        0, (previousValue, element) => previousValue + element.total);
  }

  int get totalCartItems {
    return _items.fold(
        0, (previousValue, element) => previousValue + element.quantity);
  }

  CartItemModel getCartitemById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
