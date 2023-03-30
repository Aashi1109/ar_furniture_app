import 'package:decal/helpers/material_helper.dart';
import 'package:decal/providers/rating_review_provider.dart';
import 'package:decal/widgets/review/review_item.dart';
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
      listen: false,
    ).getReviewsForProduct(routeArgsId);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            MaterialHelper.buildCustomAppbar(context, 'Review & Rating'),
            ReviewRatingHeader(),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemBuilder: (ctx, index) {
                  return ReviewItem(
                    userId: productReviews[index].userId,
                    rating: productReviews[index].rating,
                    reviewMessage: productReviews[index].reviewMessage,
                    // userName: authProvider.userName,
                  );
                },
                itemCount:
                    productReviews.length < 4 ? productReviews.length : 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
