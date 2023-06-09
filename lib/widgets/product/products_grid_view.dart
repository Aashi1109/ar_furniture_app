import 'package:flutter/material.dart';

import 'furniture_item.dart';

class ProductGridView extends StatelessWidget {
  const ProductGridView(
    this.products,
    this.mediaQuery, {
    super.key,
    this.childHeight = 245,
  });
  final double childHeight;
  final List<dynamic> products;
  final MediaQueryData mediaQuery;

  @override
  Widget build(BuildContext context) {
    return products.isEmpty
        ? const Center(
            child: Text('No items found.'),
          )
        : GridView.builder(
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: (mediaQuery.size.width * .45) / childHeight,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return FurnitureItem(
                (products)[index].id,
              );
            },
            itemCount: products.length,
          );
  }
}
