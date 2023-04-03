import 'furniture_item.dart';
import 'package:flutter/material.dart';

class ProductGridView extends StatelessWidget {
  const ProductGridView(this.products, this.mediaQuery, {super.key});
  final List<dynamic> products;
  final MediaQueryData mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: products.isEmpty
          ? const Center(
              child: Text('No items found.'),
            )
          : GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: (mediaQuery.size.width * .45) / 245,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return FurnitureItem((products)[index].id);
              },
              itemCount: products.length,
            ),
    );
  }
}
