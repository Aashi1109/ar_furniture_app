import 'package:decal/providers/cart_provider.dart';
import 'package:decal/providers/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderModal extends StatelessWidget {
  const OrderModal(
    this.totalItems,
    this.totalPrice, {
    super.key,
    required this.themeColorScheme,
    this.discount = 0,
    this.deliveryAndExtra = 0,
  });

  final ColorScheme themeColorScheme;
  final int totalItems;
  final double totalPrice;
  final double discount;
  final double deliveryAndExtra;

  @override
  Widget build(BuildContext context) {
    final orderProvider =
        Provider.of<OrderProviderModel>(context, listen: false);
    final cartProvider = Provider.of<CartProviderModel>(context, listen: false);
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * .8,
        minHeight: MediaQuery.of(context).size.height * .3,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: themeColorScheme.primary,
                  ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: Text(
                'Total items :',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: themeColorScheme.primary,
                    ),
              ),
              trailing: Text(
                totalItems.toString(),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: themeColorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            // const SizedBox(
            //   height: 5,
            // ),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Text(
                'Delivery and Assembly :',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: themeColorScheme.primary,
                    ),
              ),
              trailing: Text(
                '\$${deliveryAndExtra.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: themeColorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            // const SizedBox(
            //   height: 5,
            // ),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Text(
                'Discount :',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: themeColorScheme.primary,
                    ),
              ),
              trailing: Text(
                '\$${discount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: themeColorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Text(
                'Subtotal',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: themeColorScheme.primary,
                    ),
              ),
              trailing: Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: themeColorScheme.primary,
                    ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                orderProvider.addOrder(
                    cartProvider.carts, cartProvider.totalCartPrice);
                cartProvider.clearCart();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                minimumSize: const Size.fromHeight(35),
                padding: const EdgeInsets.all(
                  15,
                ),
              ),
              child: Text(
                'Rent',
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
