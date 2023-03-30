import 'package:decal/helpers/general_helper.dart';
import 'package:decal/helpers/material_helper.dart';
import 'package:decal/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    required this.id,
    this.title = '',
    this.quantity = 0,
    this.total = 0,
    this.imageUrl = '',
    this.isOrderItem = false,
  });
  final String id;
  final bool isOrderItem;
  final String title;
  final int quantity;
  final double total;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final themeColorScheme = Theme.of(context).colorScheme;
    final cartProvider = Provider.of<CartProviderModel>(
      context,
      listen: isOrderItem ? false : true,
    );
    final cartItem = isOrderItem ? null : cartProvider.getCartitemById(id);
    // debugPrint(cartItem?.title.toString());
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.network(
          GeneralHelper.genReducedImageUrl(
              isOrderItem ? imageUrl : cartItem!.imageUrl),
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
                    isOrderItem ? title : cartItem!.title,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: themeColorScheme.primary,
                        ),
                  ),
                  Text(
                    'x ${isOrderItem ? quantity : cartItem!.quantity}',
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
                    '\$${(isOrderItem ? total : cartItem!.total).toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: themeColorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  // }),
                ],
              ),
              if (!isOrderItem)
                Positioned(
                  right: -8,
                  bottom: 0,
                  child: SizedBox(
                    width: 107,
                    child: Row(
                      children: [
                        MaterialHelper.buildRoundedElevatedButton(
                          context,
                          Icons.remove_rounded,
                          themeColorScheme,
                          cartItem!.quantity == 1
                              ? null
                              : () {
                                  cartProvider.removeItemFromCart(prodId: id);
                                },
                          iconSize: 26,
                        ),
                        const Text(
                          '1',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        MaterialHelper.buildRoundedElevatedButton(
                          context,
                          Icons.add_rounded,
                          themeColorScheme,
                          () {
                            cartProvider.addItemToCart(
                              prodId: id,
                              title: cartItem.title,
                              price: cartItem.price,
                              quantity: 1,
                              imageUrl: cartItem.imageUrl,
                            );
                          },
                          iconSize: 26,
                        ),
                      ],
                    ),
                  ),
                ),
              if (isOrderItem)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: SizedBox(
                    child: Column(
                      children: [
                        MaterialHelper.buildRoundedElevatedButton(
                          context,
                          Icons.remove_red_eye,
                          themeColorScheme,
                          () {
                            Navigator.of(context).pushNamed(
                              ProductDetailScreen.namedRoute,
                              arguments: id,
                            );
                          },
                          iconSize: 22,
                          buttonColor: themeColorScheme.tertiary,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        MaterialHelper.buildRoundedElevatedButton(
                          context,
                          Icons.add_shopping_cart_rounded,
                          themeColorScheme,
                          () {
                            Provider.of<CartProviderModel>(
                              context,
                              listen: false,
                            ).addItemToCart(
                              prodId: id,
                              title: title,
                              price: total / quantity,
                              quantity: 1,
                              imageUrl: imageUrl,
                            );
                          },
                          iconSize: 22,
                          buttonColor: themeColorScheme.tertiary,
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
