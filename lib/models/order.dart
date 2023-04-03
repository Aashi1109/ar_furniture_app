import 'cart.dart';

class OrderItemModel {
  final String id;
  final List<CartItemModel> products;
  final double amount;
  final DateTime placedAt;

  OrderItemModel({
    required this.id,
    required this.products,
    required this.amount,
    required this.placedAt,
  });
}
