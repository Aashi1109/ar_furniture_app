import 'package:decal/providers/auth_provider.dart';
import 'package:decal/providers/rating_review_provider.dart';
import 'package:decal/screens/review_rating_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './review_item.dart';
import './review_header.dart';

class ReviewRatingSection extends StatelessWidget {
  const ReviewRatingSection(this.id, {super.key});
  final String id;

  @override
  Widget build(BuildContext context) {
    final productReviews = Provider.of<ReviewRatingProviderModel>(context)
        .getReviewsForProduct(id);
    // final authProvider = Provider.of<AuthProviderModel>(context, listen: false);
    // final userReview = Provider.of<ReviewRatingProviderModel>(context)
    //     .getUserReviewIndexonProduct(
    //         id, FirebaseAuth.instance.currentUser!.uid);

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
        SizedBox(
          height: MediaQuery.of(context).size.height *
              (0.17 * (productReviews.length < 4 ? productReviews.length : 3)),
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
            itemCount: productReviews.length < 4 ? productReviews.length : 3,
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
  }
}
