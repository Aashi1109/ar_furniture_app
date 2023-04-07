import 'package:flutter/material.dart';

import '../helpers/material_helper.dart';
import '../models/order.dart';
import 'cart/cart_item.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({
    super.key,
    required this.themeColorScheme,
    required this.orderItem,
    required this.index,
  });

  final ColorScheme themeColorScheme;
  final OrderItemModel orderItem;
  final int index;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _isExpanded = false;
  // final products = widget.orderItem.products;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: widget.themeColorScheme.tertiary,
      ),
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #${widget.index}',
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Subtotal: '),
                    Text(
                      '\$${widget.orderItem.amount.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                if (_isExpanded) ...[
                  Text(
                    'order id : #${widget.orderItem.id}',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    constraints: BoxConstraints(
                      // minHeight: MediaQuery.of(context).size.height * .1 + widget.orderItem.products.length,
                      // maxHeight: MediaQuery.of(context).size.height * (widget.orderItem.products.length),
                      maxHeight: MediaQuery.of(context).size.height *
                          (.14 *
                              (widget.orderItem.products.length < 5
                                  ? widget.orderItem.products.length
                                  : 5)),
                    ),
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          margin: const EdgeInsets.only(
                            bottom: 10,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CartItem(
                              id: widget.orderItem.products[index].id,
                              isOrderItem: true,
                              title: widget.orderItem.products[index].title,
                              total: widget.orderItem.products[index].total,
                              imageUrl:
                                  widget.orderItem.products[index].imageUrl,
                              quantity:
                                  widget.orderItem.products[index].quantity,
                            ),
                          ),
                        );
                      },
                      itemCount: widget.orderItem.products.length,
                    ),
                  ),
                ],
              ],
            ),
            Positioned(
              right: 0,
              top: -5,
              child: MaterialHelper.buildRoundedElevatedButton(
                context,
                _isExpanded
                    ? Icons.keyboard_arrow_down_rounded
                    : Icons.keyboard_arrow_right_rounded,
                widget.themeColorScheme,
                () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                borderStyle: const CircleBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
