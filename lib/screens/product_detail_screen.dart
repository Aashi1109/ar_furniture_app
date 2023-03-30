import 'package:decal/helpers/material_helper.dart';
import 'package:decal/helpers/modal_helper.dart';
import 'package:decal/providers/products_provider.dart';
import 'package:decal/providers/rating_review_provider.dart';
import 'package:decal/widgets/description.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/image_slider.dart';
import '../widgets/product_detail_bottom_tabbar.dart';
import '../widgets/star_ratings.dart';
import './review_rating_screen.dart';
import '../widgets/review/review_rating.dart';
import '../widgets/rating/rating_form.dart';

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
    final reviewProvider = Provider.of<ReviewRatingProviderModel>(
      context,
      listen: false,
    );

    final userReviewIndex = Provider.of<ReviewRatingProviderModel>(
      context,
      listen: false,
    ).getUserReviewIndexonProduct(
      routeArgsId,
    );

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
                  MaterialHelper.buildRoundedElevatedButton(
                    context,
                    null,
                    themeColorScheme,
                    () {
                      Navigator.of(context).pop();
                    },
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
              Stack(
                clipBehavior: Clip.none,
                children: [
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
                      Spacer(),
                      // const Spacer(),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    child: StarRatings(
                      reviewProvider.getAverageRatingForProduct(routeArgsId),
                      reviewProvider.getReviewsForProduct(routeArgsId).length,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
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
              // const Align(
              //   alignment: Alignment.centerLeft,
              //   child: Text(
              //     'Description',
              //     style: TextStyle(
              //       fontSize: 14,
              //     ),
              //   ),
              // ),
              // Text(
              //   foundProduct.description,
              // ),
              Description(
                foundProduct.description,
              ),
              ReviewRatingSection(routeArgsId),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ProductDetailBottomTabbar(routeArgsId),
      floatingActionButton: userReviewIndex >= 0
          ? null
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
            ),
    );
  }
}
