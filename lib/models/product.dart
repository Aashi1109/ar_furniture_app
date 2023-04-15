import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductItemModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final Map<String, dynamic> images;
  final String vector;
  final List<String> categories;
  final String modelUrl;

  bool isFavourite;

  ProductItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    required this.vector,
    required this.categories,
    required this.modelUrl,
    this.isFavourite = false,
  });

  factory ProductItemModel.fromSnapshot(
    QueryDocumentSnapshot doc,
    bool isFavourite,
  ) {
    final data = doc.data() as Map<String, dynamic>;
    // debugPrint('category ${data['category']}');
    return ProductItemModel(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      price: double.parse(data['price']),
      images: data['images'],
      vector: data['vector'],
      categories: List<String>.from(
        data['category'],
      ),
      modelUrl: data['modelUrl'] ?? '',
      isFavourite: isFavourite,
    );
  }
}
