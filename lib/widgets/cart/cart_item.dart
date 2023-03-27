import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    required this.id,
    // required this.title,
    // required this.quantity,
    // required this.price,
    // required this.imageUrl,
  });
  final String id;
  // final String title;
  // final int quantity;
  // final double price;
  // final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final themeColorScheme = Theme.of(context).colorScheme;
    final cartProvider = Provider.of<CartProviderModel>(
      context,
    );
    final cartItem = cartProvider.getCartitemById(id);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.network(
          cartItem.imageUrl,
          height: 90,
          width: 100,
          fit: BoxFit.contain,
          // color: Colors.amber,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    cartItem.title,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: themeColorScheme.primary,
                        ),
                  ),
                  // Consumer<CartProviderModel>(
                  //   builder: (context, value, child) =>
                  Text(
                    'x ${cartItem.quantity}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: themeColorScheme.primary,
                        ),
                  ),
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Consumer<CartProviderModel>(builder: (context, value, child) {
                  Text(
                    '\$${cartItem.total.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: themeColorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  // }),
                ],
              ),
              Positioned(
                right: -8,
                bottom: 0,
                child: SizedBox(
                  width: 107,
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: cartItem.quantity == 1
                            ? null
                            : () {
                                cartProvider.removeItemFromCart(prodId: id);
                              },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size.square(32),
                          maximumSize: const Size.square(32),
                          padding: EdgeInsets.zero,
                          backgroundColor: themeColorScheme.tertiary,
                        ),
                        child: Icon(
                          Icons.remove,
                          color: themeColorScheme.primary,
                        ),
                      ),
                      const Text(
                        '1',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          cartProvider.addItemToCart(
                            prodId: id,
                            title: cartItem.title,
                            price: cartItem.price,
                            quantity: 1,
                            imageUrl: cartItem.imageUrl,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size.square(32),
                          maximumSize: const Size.square(32),
                          padding: EdgeInsets.zero,
                        ),
                        child: const Icon(
                          Icons.add,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
