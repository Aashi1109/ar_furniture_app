import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/material_helper.dart';
import '../../providers/orders_provider.dart';
import '../../widgets/order/order_item.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});
  static const namedRoute = '/orders';

  @override
  Widget build(BuildContext context) {
    final orderItems = Provider.of<OrderProviderModel>(context, listen: false)
        .orders
        .reversed
        .toList();
    final themeColorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            MaterialHelper.buildCustomAppbar(
              context,
              'Orders',
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return OrderItem(
                    themeColorScheme: themeColorScheme,
                    orderItem: orderItems[index],
                    index: orderItems.length - index,
                  );
                },
                itemCount: orderItems.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
