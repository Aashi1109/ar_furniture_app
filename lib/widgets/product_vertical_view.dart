import '../providers/products_provider.dart';
import '../screens/view_more_screen.dart';
import 'furniture_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerticalSection extends StatelessWidget {
  const VerticalSection(this.header, this.category, {super.key});
  final String header;
  final String category;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProviderModel>(
      context,
    );

    final catergorizedProducts =
        productProvider.getProductsByCategory(category);
    // print(productProvider.products.toString());
    return SizedBox(
      height: 295,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                header,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(ViewMoreScreen.namedRoute,
                      arguments: category);
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: catergorizedProducts
                  .map(
                    (product) => Container(
                      margin: const EdgeInsets.only(right: 15),
                      child: FurnitureItem(product.id),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
