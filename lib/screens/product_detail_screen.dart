import 'package:decal/providers/cart_provider.dart';
import 'package:decal/providers/orders_provider.dart';

import '../helpers/material_helper.dart';
import '../helpers/modal_helper.dart';
import '../providers/products_provider.dart';
import '../providers/rating_review_provider.dart';
import '../widgets/description.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/image_slider.dart';
import '../widgets/product_detail_bottom_tabbar.dart';
import '../widgets/star_ratings.dart';
import '../widgets/review/review_rating.dart';
import '../widgets/review/review_form.dart';
import '../constants.dart';

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
          right: kDefaultPadding,
          left: kDefaultPadding,
          top: kDefaultPadding + 20,
          bottom: kDefaultPadding,
        ),
        child: FutureBuilder(
            future: Future.wait(
              [
                Provider.of<OrderProviderModel>(context, listen: false)
                    .getAndSetOrdersData(),
                Provider.of<CartProviderModel>(context, listen: false)
                    .getAndSetCartData(),
              ],
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        // this will show images of product
                        SizedBox(
                          height: mediaQuery.size.height * .3,
                          child: ImageSlider(routeArgsId),
                        ),

                        // Button to go back to previous screen
                        MaterialHelper.buildRoundedElevatedButton(
                          context,
                          null,
                          themeColorScheme,
                          () {
                            Navigator.of(context).pop();
                          },
                        ),

                        // This is show favourite status of product
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

                    // This is to show actual product details
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // To show title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                foundProduct.title,
                                // 'adjfad afdafaryrg sggshs',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                      color: themeColorScheme.primary,
                                    ),
                                softWrap: true,
                              ),
                            ),
                            const Spacer(),
                            // const Spacer(),
                          ],
                        ),

                        // To show rating for product
                        Positioned(
                          right: 0,
                          child: Consumer<ReviewRatingProviderModel>(
                            builder: (context, provider, ch) {
                              return StarRatings(
                                provider
                                    .getAverageRatingForProduct(routeArgsId),
                                provider
                                    .getReviewsForProduct(routeArgsId)
                                    .length,
                              );
                            },
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // To show product price
                    Row(
                      children: [
                        const Text('Price : '),
                        Text(
                          '\$${foundProduct.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleLarge,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    // To show product description
                    Description(
                      foundProduct.description,
                    ),

                    // To show reviews section
                    ReviewRatingSection(routeArgsId),
                  ],
                ),
              );
            }),
      ),
      bottomNavigationBar: ProductDetailBottomTabbar(routeArgsId),
      floatingActionButton:
          Consumer<ReviewRatingProviderModel>(builder: (context, provider, ch) {
        final userReviewIndex =
            provider.getUserReviewIndexonProduct(routeArgsId);
        return userReviewIndex >= 0
            ? const SizedBox.shrink()
            : ElevatedButton.icon(
                onPressed: () {
                  ModalHelpers.createBottomModal(
                    context,
                    ReviewRatingForm(routeArgsId),
                  );
                },
                icon: const Icon(
                  Icons.edit_rounded,
                ),
                label: const Text('Write a Review'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                  backgroundColor: themeColorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              );
      }),
    );
  }
}
