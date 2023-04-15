import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../helpers/firebase/profile_helper.dart';
import '../../helpers/material_helper.dart';
import '../../helpers/modal_helper.dart';
import '../inputs/description.dart';
import 'review_form.dart';

class ReviewItem extends StatelessWidget {
  const ReviewItem({
    super.key,
    required this.userId,
    required this.productId,
    required this.rating,
    required this.reviewMessage,
    required this.reviewId,
  });
  final String userId;
  final String reviewMessage;
  final int rating;
  final String productId;
  final String reviewId;

  // final String userImageUrl;
  // String? userImageUrl;
  // String? userName;

  @override
  Widget build(BuildContext context) {
    // final authData = await FirebaseHelper.getUserProfileDataFromFirestore();
    final curUserId = FirebaseAuth.instance.currentUser?.uid;
    final isUserReview = curUserId == userId;
    // debugPrint(curUserId);
    // debugPrint(reviewId);

    return FutureBuilder(
        future: ProfileHelper.getUserProfileDataFromFirestore(
          userId: userId,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            debugPrint(
                'error in fetching userData ${snapshot.error.toString()}');
          }

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.tertiary,
              border: isUserReview
                  ? Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    )
                  : null,
            ),
            margin: const EdgeInsets.only(
              bottom: 10,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(snapshot.data?.data()?['imageUrl']),
                        radius: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(snapshot.data?.data()?['name']),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded),
                          Text(
                            rating.toString(),
                            textAlign: TextAlign.justify,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          if (isUserReview) ...[
                            const SizedBox(
                              width: 5,
                            ),
                            MaterialHelper.buildRoundedElevatedButton(
                              context,
                              Icons.edit_rounded,
                              () {
                                ModalHelpers.createBottomModal(
                                  context,
                                  ReviewRatingForm(
                                    productId,
                                    isEditForm: true,
                                  ),
                                );
                              },
                              iconSize: 20,
                              buttonSize: 30,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // const Divider(),
                  Description(
                    // '$reviewMessage \n $reviewId',
                    reviewMessage,
                    bgColor: Theme.of(context).colorScheme.onPrimary,
                    title: 'Review',
                  ),
                ],
              ),
            ),
          );
        });
  }
}
