class CartItemModel {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;
  final double total;

  CartItemModel({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    required this.imageUrl,
    // this.total = this.price * this.quantity,
  }) : total = price * quantity;
}
