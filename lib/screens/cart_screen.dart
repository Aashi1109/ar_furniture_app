import '../helpers/material_helper.dart';
import '../helpers/modal_helper.dart';
import '../providers/cart_provider.dart';
import '../widgets/order_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  static const namedRoute = '/cart';

  @override
  Widget build(BuildContext context) {
    final themeColorScheme = Theme.of(context).colorScheme;
    final cartProvider = Provider.of<CartProviderModel>(context).items;

    debugPrint(cartProvider.length.toString());

    return Scaffold(
      backgroundColor: themeColorScheme.tertiary,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MaterialHelper.buildCustomAppbar(
              context,
              'Checkout',
            ),
            Consumer<CartProviderModel>(
              builder: (context, provider, ch) {
                return Expanded(
                  child: provider.items.isEmpty
                      ? ch!
                      : ListView.builder(
                          itemBuilder: (ctx, index) {
                            return Container(
                              margin: const EdgeInsets.only(
                                bottom: 20,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CartItem(
                                    id: provider.items[index].id,
                                  ),
                                  const Divider(),
                                ],
                              ),
                            );
                          },
                          itemCount: provider.items.length,
                        ),
                );
              },
              child: const Center(
                child: Text('No items in cart.'),
              ),
            ),
            Consumer<CartProviderModel>(
              builder: (context, provider, child) => provider.items.isEmpty
                  ? const SizedBox.shrink()
                  : ElevatedButton(
                      onPressed: () {
                        ModalHelpers.createBottomModal(
                          context,
                          OrderModal(
                            themeColorScheme: themeColorScheme,
                            provider.totalCartItems,
                            provider.totalCartPrice,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        minimumSize: const Size.fromHeight(35),
                        padding: const EdgeInsets.all(
                          15,
                        ),
                      ),
                      child: child,
                    ),
              child: Text(
                'Empty Cart',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
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
