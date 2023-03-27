import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decal/helpers/firebase_helper.dart';
import 'package:decal/models/cart.dart';

import 'package:flutter/material.dart';

class CartProviderModel with ChangeNotifier {
  final List<CartItemModel> _items = [];
  Map<String, List<CartItemModel>> _cart = {};

  List<CartItemModel> get items => _items;

  void addItemToCart({
    required String prodId,
    required String title,
    required double price,
    required int quantity,
    required String imageUrl,
  }) {
    final existingCartitemIndex =
        _items.indexWhere((element) => element.id == prodId);

    if (existingCartitemIndex >= 0) {
      final existingCartitem = _items[existingCartitemIndex];
      final modifiedCartItem = CartItemModel(
        id: prodId,
        title: title,
        quantity: quantity + existingCartitem.quantity,
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

  Future<void> pushCartDataToFirestore() async {
    try {
      final userCartCollection = FirebaseHelper.getUserCartCollection();
      await userCartCollection.add({
        'items': _items.map((cartItem) => {
              'id': cartItem.id,
              'title': cartItem.title,
              'price': cartItem.price,
              'quantity': cartItem.quantity,
              'total': cartItem.total,
              'imageUrl': cartItem.imageUrl,
              'createdAt': Timestamp.now(),
            })
      });
      // .then((value) {
      //   _cart[value.id] = _items;
      // });
    } catch (error) {
      debugPrint(error.toString());
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
