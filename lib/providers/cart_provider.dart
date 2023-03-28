import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decal/helpers/firebase_helper.dart';
import 'package:decal/models/cart.dart';

import 'package:flutter/material.dart';

class CartProviderModel with ChangeNotifier {
  //  _items = [];
  // Map<String, dynamic> _cart = {
  //   'items': <CartItemModel>[],
  //   'isOrdered': false,
  // };
  bool _isOrdered = false;
  List<CartItemModel> _items = [];

  List<CartItemModel> get items {
    // if (_cart['isOrdered']) {
    //   _items;
    // }
    // return [];
    if (!_isOrdered) {
      return [..._items];
    }
    return [];
  }

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
      // debugPrint('in update item');
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
    }
    notifyListeners();
  }

  void removeItemFromCart({
    required String prodId,
  }) {
    // _items.remove(item);
    final existingCartitemIndex =
        _items.indexWhere((element) => element.id == prodId);

    if (existingCartitemIndex >= 0) {
      final existingCartitem = _items[existingCartitemIndex];

      final modifiedCartItem = CartItemModel(
        id: prodId,
        title: existingCartitem.title,
        quantity: existingCartitem.quantity - 1,
        price: existingCartitem.price,
        imageUrl: existingCartitem.imageUrl,
      );
      debugPrint('in remove item');
      _items[existingCartitemIndex] = modifiedCartItem;
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  Future<void> pushCartDataToFirestore({bool isSave = true}) async {
    debugPrint('in cart push');
    try {
      await FirebaseHelper.setCartDataInFirestore({
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

      clearCart();
    } catch (error) {
      debugPrint('error in storing cart data to firestore ${error.toString()}');
    }
  }

  Future<void> getAndSetCartData() async {
    try {
      final cartData = await FirebaseHelper.getCartDataFromFirestore();
      if (cartData == null) {
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
      notifyListeners();
    } catch (error) {
      debugPrint(
          'error in getting cart data from firestore ${error.toString()}');
    }
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

  List<CartItemModel> get carts {
    return [..._items];
  }
}
