import 'package:decal/helpers/material_helper.dart';
import 'package:decal/helpers/modal_helper.dart';
import 'package:decal/providers/cart_provider.dart';
import 'package:decal/widgets/order_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  static const namedRoute = '/cart';

  @override
  Widget build(BuildContext context) {
    // final mediaQuery = MediaQuery.of(context);
    final themeColorScheme = Theme.of(context).colorScheme;
    final cartProvider = Provider.of<CartProviderModel>(
      context,
      listen: false,
    );
    // debugPrint('cart length ${cartProvider.carts.length}');

    return Scaffold(
      backgroundColor: themeColorScheme.tertiary,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: cartProvider.items.isEmpty
              ? [
                  MaterialHelper.buildCustomAppbar(
                    context,
                    'Checkout',
                    // onPress: () {
                    //   cartProvider.pushCartDataToFirestore();
                    // },
                    () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const Expanded(
                    child: Center(
                      child: Text('No cart items found.'),
                    ),
                  ),
                ]
              : [
                  MaterialHelper.buildCustomAppbar(context, 'Checkout', () {
                    Navigator.of(context).pop();
                  }),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (ctx, index) {
                        return Container(
                          margin: const EdgeInsets.only(
                            bottom: 20,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CartItem(
                                id: cartProvider.carts[index].id,
                              ),
                              const Divider(),
                            ],
                          ),
                        );
                      },
                      itemCount: cartProvider.carts.length,
                    ),
                  ),
                  // const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      ModalHelpers.createBottomModal(
                        context,
                        OrderModal(
                          themeColorScheme: themeColorScheme,
                          cartProvider.totalCartItems,
                          cartProvider.totalCartPrice,
                        ),
                      );
                      // cartProvider.clearCart();
                      // cartProvider.pushCartDataToFirestore();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      minimumSize: const Size.fromHeight(35),
                      padding: const EdgeInsets.all(
                        15,
                      ),
                    ),
                    child: Text(
                      'Empty Cart',
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: themeColorScheme.onPrimary,
                              ),
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
