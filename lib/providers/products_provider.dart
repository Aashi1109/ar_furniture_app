import 'package:flutter/material.dart';

import '../helpers/firebase/favourite_helper.dart';
import '../helpers/firebase/product_helper.dart';
import '../helpers/general_helper.dart';
import '../models/product.dart';

class ProductProviderModel extends ChangeNotifier {
  List<ProductItemModel> _products = [];
  List<String> _favourites = [];
  bool _isProductDataInit = true;

  List<ProductItemModel> get products {
    return [..._products];
  }

  List get favourites {
    return [..._favourites];
  }

  Future<void> addProduct(
    Map<String, Object> productData, {
    String? productId,
    int? updateIndex,
  }) async {
    final productItem = ProductItemModel(
      id: productId ?? DateTime.now().toString(),
      title: productData['title']! as String,
      description: productData['description']! as String,
      price: double.parse(productData['price']! as String),
      images: productData['imagesFor']! as Map<String, Object>,
      vector: productData['vector']! as String,
      categories: productData['category']! as List<String>,
      modelUrl: productData['modelUrl']! as String,
    );

    if (productId != null && updateIndex != null) {
      _products[updateIndex] = productItem;
      notifyListeners();
    } else {
      _products.insert(
        0,
        productItem,
      );
      getAndSetProducts(
        isUpdate: true,
      );
    }

    try {
      // productData.remove('images');
      await ProductHelper.addProductInFirestore(
        productData,
        productId: productId,
      );
    } catch (error) {
      debugPrint('error in adding product to firestore $error');
      if (productId == null) {
        _products.removeAt(0);
        notifyListeners();
      }
    }
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
        id,
        product.isFavourite,
      );
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

  Future<void> getAndSetProducts({
    bool isUpdate = false,
  }) async {
    // debugPrint('sdkdsjdjfdjndndkfndakkad');
    return GeneralHelper.getAndSetWrapper(_isProductDataInit || isUpdate,
        () async {
      final productsCollection = ProductHelper.getProductsCollection();
      final products = await productsCollection
          .orderBy(
            'createdAt',
            descending: true,
          )
          .get();
      await getAndSetFavourites();

      // print(products);
      final List<ProductItemModel> loadedProducts = [];
      for (var element in products.docs) {
        loadedProducts.add(
          ProductItemModel.fromSnapshot(
            element,
            _favourites.contains(element.id) ? true : false,
          ),
        );
      }
      // print(loadedProducts.toString());

      _products = loadedProducts;
      _isProductDataInit = false;

      notifyListeners();
    });
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

  Future<void> removeProductById(String productId) async {
    _products.removeWhere(
      (element) => element.id == productId,
    );
    notifyListeners();
    try {
      ProductHelper.removeProductFromFirestore(productId);
    } catch (error) {
      debugPrint('error in deleting product $error');
    }
  }

  Future<void> updateProductById(
      String productId, Map<String, Object> productData) async {
    final existingProductIndex =
        _products.indexWhere((element) => element.id == productId);
    if (existingProductIndex >= 0) {
      addProduct(
        productData,
        productId: productId,
        updateIndex: existingProductIndex,
      );
    }
  }
}
