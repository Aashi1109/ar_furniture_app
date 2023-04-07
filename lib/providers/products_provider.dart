import '../helpers/general_helper.dart';

import '../helpers/firebase/favourite_helper.dart';
import '../helpers/firebase/product_helper.dart';
import '../helpers/firebase_helper.dart';
import '../models/product.dart';
import 'package:flutter/material.dart';

class ProductProviderModel extends ChangeNotifier {
  List<ProductItemModel> _products = [];
  List<String> _favourites = [];
  bool _isProductDataInit = true;

  List get products {
    return [..._products];
  }

  List get favourites {
    return [..._favourites];
  }

  void addProduct(ProductItemModel product) {
    _products.add(product);
    notifyListeners();
  }

  ProductItemModel getProductById(String id) {
    return _products.firstWhere((element) => element.id == id);
  }

  void toggleFavourite(String id) async {
    final product = getProductById(id);
    // debugPrint(product.toString());
    final prevFavStat = product.isFavourite;
    product.isFavourite = !product.isFavourite;
    if (product.isFavourite) {
      _favourites.add(product.id);
    } else {
      _favourites.remove(product.id);
    }
    // debugPrint('in fav');

    notifyListeners();
    try {
      await FavouriteHelper.toggleFavouritesInFirestore(
          id, product.isFavourite);
    } catch (error) {
      product.isFavourite = prevFavStat;
      if (product.isFavourite) {
        _favourites.add(product.id);
      } else {
        _favourites.remove(product.id);
      }
      notifyListeners();
      debugPrint('Error updating fav stat');
    }
  }

  Future<void> getAndSetProducts() async {
    // debugPrint('sdkdsjdjfdjndndkfndakkad');
    return GeneralHelper.getAndSetWrapper(_isProductDataInit, () async {
      final productsCollection = ProductHelper.getProductsCollection();
      final products = await productsCollection.get();
      await getAndSetFavourites();

      // print(products);
      final List<ProductItemModel> loadedProducts = [];
      for (var element in products.docs) {
        // print(element.data()['images']['main']);
        // print(element.data()['modelUrl']);
        loadedProducts.add(ProductItemModel(
          id: element.id,
          title: element.data()['title'],
          description: element.data()['description'],
          price: double.parse(element.data()['price']),
          images: Map<String, dynamic>.from(element.data()['images']),

          vector: element.data()['vector'],
          categories: List<String>.from(element.data()['category']),
          modelUrl: element.data()['modelUrl'] ?? '',
          isFavourite: _favourites.contains(element.id) ? true : false,
          // rating: 4.5, // Have to be fetched from firebase
        ));
      }
      // print(loadedProducts.toString());

      _products = loadedProducts;
      // print(products.docs);
      notifyListeners();
    });
    // try {
    // final productsCollection = ProductHelper.getProductsCollection();
    // final products = await productsCollection.get();
    // await getAndSetFavourites();

    // // print(products);
    // final List<ProductItemModel> loadedProducts = [];
    // for (var element in products.docs) {
    //   // print(element.data()['images']['main']);
    //   // print(element.data()['modelUrl']);
    //   loadedProducts.add(ProductItemModel(
    //     id: element.id,
    //     title: element.data()['title'],
    //     description: element.data()['description'],
    //     price: double.parse(element.data()['price']),
    //     images: Map<String, dynamic>.from(element.data()['images']),

    //     vector: element.data()['vector'],
    //     categories: List<String>.from(element.data()['category']),
    //     modelUrl: element.data()['modelUrl'] ?? '',
    //     isFavourite: _favourites.contains(element.id) ? true : false,
    //     // rating: 4.5, // Have to be fetched from firebase
    //   ));
    // }
    // // print(loadedProducts.toString());

    // _products = loadedProducts;
    // // print(products.docs);
    // notifyListeners();
    // } catch (error) {
    //   debugPrint(error.toString());
    // }
  }

  Future<void> getAndSetFavourites() async {
    final userFavouritesCollection =
        FavouriteHelper.getUserFavouritesCollection();
    final favourites = await userFavouritesCollection.get();
    final List<String> loadedFavourites = [];
    for (var element in favourites.docs) {
      if (element.data()['isFavourite']) {
        loadedFavourites.add(element.id);
      }
    }

    _favourites = loadedFavourites;
  }

  List<ProductItemModel> getProductsByCategory(String category) {
    return _products
        .where((element) => element.categories.contains(category))
        .toList();
  }

  List<ProductItemModel> getProductsByQuery(String query) {
    return _products.where((prod) {
      if (prod.title.toLowerCase().contains(query)) {
        return true;
      }
      if (prod.categories.contains(query)) {
        return true;
      }

      return false;
    }).toList();
  }
}
