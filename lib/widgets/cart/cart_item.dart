import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart_provider.dart';
import '../../providers/general_provider.dart';
import '../../helpers/general_helper.dart';
import '../../helpers/material_helper.dart';
import '../../screens/product/product_detail_screen.dart';

/// It is used to show items of cart and order.
/// Based on isOrderItem it is decided whether it is item of order or not.
/// It true it is order item.
/// When it is order item non required parameters are used like [total], [title],
/// [quantity] and [imageUrl].
///
/// When it is cart item it uses `CartProviderModel` to get all these values.
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
      // listen: isOrderItem ? false : true,
      listen: false,
    );
    final cartItem = isOrderItem ? null : cartProvider.getCartitemById(id);
    final isDataSaverOn =
        Provider.of<GeneralProviderModel>(context, listen: false).isDataSaverOn;
    // debugPrint(cartItem?.title.toString());
    final tempImgUrl = isOrderItem ? imageUrl : cartItem!.imageUrl;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FadeInImage(
          image: NetworkImage(
            !isDataSaverOn
                ? tempImgUrl
                : GeneralHelper.genReducedImageUrl(
                    tempImgUrl,
                  ),
            // color: Colors.amber,
          ),
          placeholder: const AssetImage('assets/images/defaults/product.jpeg'),
          height: 90,
          width: 100,
          fit: BoxFit.contain,
          imageErrorBuilder: (context, error, stackTrace) => Image.asset(
            'assets/images/default/default_product.png',
          ),
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
                  bottom: 2,
                  child: SizedBox(
                    width: 107,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MaterialHelper.buildRoundedElevatedButton(
                          context,
                          Icons.remove_rounded,
                          cartItem!.quantity == 1
                              ? null
                              : () {
                                  cartProvider.removeItemFromCart(prodId: id);
                                },
                          iconSize: 26,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                          child: Text(
                            '1',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        MaterialHelper.buildRoundedElevatedButton(
                          context,
                          Icons.add_rounded,
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
                          height: 20,
                        ),
                        MaterialHelper.buildRoundedElevatedButton(
                          context,
                          Icons.add_shopping_cart_rounded,
                          () {
                            cartProvider.addItemToCart(
                              prodId: id,
                              title: title,
                              price: total / quantity,
                              quantity: 1,
                              imageUrl: imageUrl,
                            );
                            // if (cartProvider.wasCartEmpty &&
                            //     cartProvider.items.isNotEmpty) {
                            //   Provider.of<NotificationProviderModel>(
                            //     context,
                            //     listen: false,
                            //   ).addNotification(
                            //     NotificationItemModel(
                            //       text: cartNotifications['t1']!['text']!,
                            //       id: DateTime.now().toString(),
                            //       title: cartNotifications['t1']!['title']!,
                            //       icon: Icons.shopping_cart_rounded,
                            //     ),
                            //   );
                            // }
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
