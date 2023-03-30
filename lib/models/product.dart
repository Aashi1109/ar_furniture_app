class ProductItemModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final Map<String, dynamic> images;
  final String vector;
  final List<String> categories;
  final String modelUrl;
  final Map<String, dynamic> rating;
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
    this.rating = const {'value': 4.5, 'count': 34},
    this.isFavourite = false,
  });
}
