import 'package:decal/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/image_slider.dart';
import '../widgets/product_detail_bottom_tabbar.dart';
import '../widgets/star_ratings.dart';

class ProductDetailScreen extends StatelessWidget {
  static const namedRoute = '/product-detail';
  const ProductDetailScreen({super.key});
  // final String id;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final themeColorScheme = Theme.of(context).colorScheme;
    final routeArgsId = ModalRoute.of(context)?.settings.arguments as String;

    final foundProduct =
        Provider.of<ProductProviderModel>(context, listen: false)
            .getProductById(routeArgsId);
    return Scaffold(
      backgroundColor: themeColorScheme.onPrimary,
      body: Padding(
        padding: const EdgeInsets.only(
          right: 20,
          left: 20,
          top: 40,
          bottom: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: mediaQuery.size.height * .3,
                    child: ImageSlider(routeArgsId),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size.square(32),
                      maximumSize: const Size.square(32),
                      padding: EdgeInsets.zero,
                      backgroundColor: themeColorScheme.tertiary,
                    ),
                    child: Icon(
                      Icons.keyboard_arrow_left_rounded,
                      color: themeColorScheme.primary,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 5,
                    child: Consumer<ProductProviderModel>(
                        builder: (context, productProvider, ch) {
                      return IconButton(
                        onPressed: () {
                          productProvider.toggleFavourite(routeArgsId);
                        },
                        icon: Icon(
                          foundProduct.isFavourite
                              ? Icons.favorite_rounded
                              : Icons.favorite_outline_rounded,
                          color: themeColorScheme.primary,
                          size: 30,
                        ),
                        // style: IconButton.styleFrom(),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      );
                    }),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      foundProduct.title,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: themeColorScheme.primary,
                          ),
                      softWrap: true,
                    ),
                  ),
                  // const Spacer(),
                  StarRatings(4.5, 16),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text('Price : '),
                  Text(
                    '\$${foundProduct.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge,
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                foundProduct.description,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ProductDetailBottomTabbar(routeArgsId),
    );
  }
}
