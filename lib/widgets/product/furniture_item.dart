import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/general_helper.dart';
import '../../providers/general_provider.dart';
import '../../providers/products_provider.dart';
import '../../screens/product/product_detail_screen.dart';

class FurnitureItem extends StatelessWidget {
  const FurnitureItem(this.id, {super.key});
  final String id;

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    final themeColorScheme = Theme.of(context).colorScheme;
    final foundProduct =
        Provider.of<ProductProviderModel>(context, listen: false)
            .getProductById(id);
    final settingsProvider =
        Provider.of<GeneralProviderModel>(context, listen: false);
    final isDataSaverOn = settingsProvider.isDataSaverOn;
    final isCurrencyInUs = settingsProvider.isCurrencyInUs;

    return Container(
      margin: const EdgeInsets.only(
          // right: 15,
          ),
      width: mediaSize.width * .45,
      height: 245,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: themeColorScheme.tertiary,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${isCurrencyInUs ? "\$" : "\u20B9"}${GeneralHelper.removeZerosFromPrice(
                        foundProduct.price,
                        isUs: isCurrencyInUs,
                      )}',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: themeColorScheme.primary,
                          ),
                    ),
                  ),
                ),
                Consumer<ProductProviderModel>(
                    builder: (context, productProvider, ch) {
                  return IconButton(
                    onPressed: () {
                      productProvider.toggleFavourite(id);
                    },
                    icon: Icon(
                      foundProduct.isFavourite
                          ? Icons.favorite_rounded
                          : Icons.favorite_outline_rounded,
                      color: themeColorScheme.primary,
                      size: 25,
                    ),
                    // style: IconButton.styleFrom(),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  );
                }),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            // Image.asset(
            //   'assets/images/sofa.png',
            //   height: 100,
            //   width: double.infinity,
            //   fit: BoxFit.cover,
            // ),
            FadeInImage(
              image: NetworkImage(
                // foundProduct.images['main'] as String,
                !isDataSaverOn
                    ? foundProduct.images['main']
                    : GeneralHelper.genReducedImageUrl(
                        foundProduct.images['main'],
                      ),
              ),
              placeholder:
                  const AssetImage('assets/images/defaults/product.jpeg'),
              height: 100,
              width: double.infinity,
              fit: BoxFit.contain,
              imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/images/default/default_product.png',
                height: 100,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            FittedBox(
              fit: BoxFit.contain,
              child: Text(
                foundProduct.title,
                style: TextStyle(
                  color: themeColorScheme.primary,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(ProductDetailScreen.namedRoute, arguments: id);
              },
              style: TextButton.styleFrom(
                backgroundColor: themeColorScheme.onTertiary,
                minimumSize: const Size.fromHeight(40),
              ),
              child: const Text('View Details'),
            ),
          ],
        ),
      ),
    );
  }
}
