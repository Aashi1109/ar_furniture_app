import 'package:decal/helpers/firebase_helper.dart';
import 'package:decal/widgets/description.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class ReviewItem extends StatelessWidget {
  const ReviewItem({
    super.key,
    required this.userId,
    // required this.userName,
    required this.rating,
    required this.reviewMessage,
    this.isUserMessage,
  });
  final String userId;
  final String reviewMessage;
  final int rating;
  final bool? isUserMessage;
  // final String userImageUrl;
  // String? userImageUrl;
  // String? userName;

  @override
  Widget build(BuildContext context) {
    // final authData = await FirebaseHelper.getUserProfileDataFromFirestore();
    return FutureBuilder(
        future: FirebaseHelper.getUserProfileDataFromFirestore(
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
              border: userId == FirebaseAuth.instance.currentUser?.uid
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
                      Text(
                        rating.toString(),
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // const Divider(),
                  Description(
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
