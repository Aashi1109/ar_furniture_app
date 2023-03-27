class ProductItemModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final Map<String, List<dynamic>> images;
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
}
