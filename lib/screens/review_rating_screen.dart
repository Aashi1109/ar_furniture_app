import '../helpers/material_helper.dart';
import '../providers/rating_review_provider.dart';
import '../widgets/review/review_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../widgets/review/review_header.dart';

class ReviewRatingScreen extends StatelessWidget {
  const ReviewRatingScreen({super.key});
  static const String namedRoute = '/review_rating_screen';

  @override
  Widget build(BuildContext context) {
    final routeArgsId = ModalRoute.of(context)?.settings.arguments as String;
    final productReviews = Provider.of<ReviewRatingProviderModel>(
      context,
      // listen: false,
    ).getReviewsForProduct(routeArgsId);

    final averageRating = Provider.of<ReviewRatingProviderModel>(
      context,
      listen: false,
    ).getAverageRatingForProduct(
      routeArgsId,
    );

    Map<int, int> ratingData = {
      1: 0,
      2: 0,
      3: 0,
      4: 0,
      5: 0,
    };

    for (var review in productReviews) {
      // debugPrint(review.toString());
      if (ratingData.containsKey(review.rating)) {
        ratingData[review.rating] = (ratingData[review.rating] ?? 0) + 1;
      } else {
        ratingData[review.rating] = 1;
      }
    }
    // debugPrint(ratingData.toString());
    int maxValue = ratingData.values.reduce((a, b) => a > b ? a : b);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            MaterialHelper.buildCustomAppbar(context, 'Review & Rating'),
            ReviewRatingHeader(
              rateData: ratingData,
              maxNoOfRating: maxValue,
              totalNoOfRatings: productReviews.length,
              averageRating: averageRating,
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: productReviews.isEmpty
                  ? const Center(
                      child: Text('No reviews yet'),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemBuilder: (ctx, index) {
                        return ReviewItem(
                          productId: routeArgsId,
                          userId: productReviews[index].userId,
                          rating: productReviews[index].rating,
                          reviewMessage: productReviews[index].reviewMessage,
                          reviewId: productReviews[index].reviewId,
                          // userName: authProvider.userName,
                        );
                      },
                      itemCount: productReviews.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
