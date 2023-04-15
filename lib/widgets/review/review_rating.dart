import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/rating_review_provider.dart';
import '../../screens/product/review_rating_screen.dart';
import 'review_item.dart';

class ReviewRatingSection extends StatelessWidget {
  const ReviewRatingSection(this.id, {super.key});
  final String id;

  @override
  Widget build(BuildContext context) {
    // final productReviews = Provider.of<ReviewRatingProviderModel>(context)
    //     .getReviewsForProduct(id);

    return FutureBuilder(
        future: Provider.of<ReviewRatingProviderModel>(
          context,
          listen: false,
        ).getAndSetReviews(),
        builder: (_, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator.adaptive();
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // ReviewRatingHeader(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Text('Rating and Reviews'),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      ReviewRatingScreen.namedRoute,
                      arguments: id,
                    );
                  },
                  icon: const Icon(
                    Icons.keyboard_arrow_right_rounded,
                  ),
                ),
              ),
              Consumer<ReviewRatingProviderModel>(builder: (_, provider, ch) {
                final productReviews = provider.getReviewsForProduct(id);
                return Column(
                  children: [
                    if (productReviews.isEmpty) const Text('No reviews yet'),
                    SizedBox(
                      height: MediaQuery.of(context).size.height *
                          (0.15 *
                              (productReviews.length < 4
                                  ? productReviews.length
                                  : 3)),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemBuilder: (ctx, index) {
                          return ReviewItem(
                            productId: id,
                            userId: productReviews[index].userId,
                            rating: productReviews[index].rating,
                            reviewMessage: productReviews[index].reviewMessage,
                            reviewId: productReviews[index].reviewId,
                            // userName: authProvider.userName,
                          );
                        },
                        itemCount: productReviews.length < 4
                            ? productReviews.length
                            : 3,
                      ),
                    ),
                    if (productReviews.length > 3) ...[
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              ReviewRatingScreen.namedRoute,
                              arguments: id,
                            );
                          },
                          child: Text(
                            // 'Show ${_isExpanded ? 'less' : 'more'} >>',
                            'View all reviews',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              }),
            ],
          );
        });
  }
}
