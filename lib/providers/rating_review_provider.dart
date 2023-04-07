import '../constants.dart';
import '../helpers/general_helper.dart';

import '../helpers/firebase/review_helper.dart';

import '../models/rating_review.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'notification_provider.dart';

class ReviewRatingProviderModel extends ChangeNotifier {
  NotificationProviderModel? _notificationProvider;

  set notificationProvider(NotificationProviderModel notificationProvider) {
    _notificationProvider = notificationProvider;
  }

  Map<String, dynamic> _reviews = {};
  bool _isReviewDataInit = true;

  Map<String, List<ReviewRatingItemModel>> get reviews {
    // debugPrint(' reviews getter called');
    return {..._reviews};
  }

  int getUserReviewIndexonProduct(String productId) {
    // debugPrint(' user review index called');
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (_reviews.containsKey(productId)) {
      return (_reviews[productId] as List).indexWhere(
        (element) => element.userId == currentUserId,
      );
    }

    return -1;
  }

  List<ReviewRatingItemModel> getReviewsForProduct(
    String productId,
  ) {
    // debugPrint('get review for product called');
    if (_reviews.containsKey(productId)) {
      return [..._reviews[productId]];
    }
    return [];
  }

  void moveUserReviewOnTop() {
    // debugPrint('move user review called');
    final tempReviews = {..._reviews};
    tempReviews.forEach((key, value) {
      final userReviewIndex = getUserReviewIndexonProduct(key);
      if (userReviewIndex >= 0) {
        final existingReview = tempReviews[key][userReviewIndex];
        (tempReviews[key] as List).removeAt(userReviewIndex);
        (tempReviews[key] as List).insert(0, existingReview);
      }
    });

    _reviews = tempReviews;
  }

  void addReview(
    String productId,
    Map<String, String> reviewData, {
    bool isDataSet = false,
  }) {
    // debugPrint('add user review called');
    if (_reviews.containsKey(productId)) {
      _reviews[productId]?.add(
        ReviewRatingItemModel(
          reviewId:
              isDataSet ? reviewData['reviewId']! : DateTime.now().toString(),
          rating: int.parse(reviewData['rating']!),
          reviewMessage: reviewData['message']!,
          userId: reviewData['userId']!,
          // productId: productId,
        ),
      );
    } else {
      _reviews[productId] = List<ReviewRatingItemModel>.from(
        [
          ReviewRatingItemModel(
            reviewId:
                isDataSet ? reviewData['reviewId']! : DateTime.now().toString(),
            rating: int.parse(reviewData['rating']!),
            reviewMessage: reviewData['message']!,
            userId: reviewData['userId']!,
          ),
        ],
      );
    }

    _notificationProvider?.addNotification(
      NotificationItemModel(
        text: reviewNotification['t1']!['text']!,
        id: DateTime.now().toString(),
        title: reviewNotification['t1']!['title']!,
        icon: Icons.add_comment_rounded,
        action: {
          'action': 'review',
          'params': productId,
        },
      ),
    );
    if (!isDataSet) {
      try {
        ReviewHelper.addReviewsInFirestore(
          {
            ...reviewData,
            'productId': isDataSet ? reviewData['productId'] : productId,
          },
        );
      } catch (error) {
        debugPrint('error in saving review data ${error.toString()}');
      }
      notifyListeners();
    }
  }

  Future<void> getAndSetReviews() async {
    // debugPrint('get and set review called');
    return GeneralHelper.getAndSetWrapper(_isReviewDataInit, () async {
      try {
        final reviewData = await ReviewHelper.getReviewsFromFirestore();
        // debugPrint(reviewData.docs.toString());

        for (var element in reviewData.docs) {
          // debugPrint(element.data().toString());
          addReview(
            element.data()['productId'],
            {
              'rating': element.data()['rating'],
              'message': element.data()['message'],
              'userId': element.data()['userId'],
              'reviewId': element.id,
            },
            isDataSet: true,
          );
        }

        moveUserReviewOnTop();
        _isReviewDataInit = false;
        notifyListeners();
      } catch (error) {
        debugPrint('error in getting product reviews ${error.toString()}');
      }
    });
    // debugPrint('in review fetch');
    // if (_reviews.isEmpty) {
    // try {
    //   final reviewData = await ReviewHelper.getReviewsFromFirestore();
    //   // debugPrint(reviewData.docs.toString());

    //   for (var element in reviewData.docs) {
    //     // debugPrint(element.data().toString());
    //     addReview(
    //       element.data()['productId'],
    //       {
    //         'rating': element.data()['rating'],
    //         'message': element.data()['message'],
    //         'userId': element.data()['userId'],
    //         'reviewId': element.id,
    //       },
    //       isDataSet: true,
    //     );
    //   }

    //   moveUserReviewOnTop();
    // } catch (error) {
    //   debugPrint('error in getting product reviews ${error.toString()}');
    // }
    // } else {
    //   return;
    // }
  }

  double getAverageRatingForProduct(String productId) {
    // debugPrint('get average rating review called');
    final reviews = getReviewsForProduct(productId);
    final totalReview = reviews.fold(
        0, (previousValue, element) => previousValue + element.rating);
    return (totalReview / (reviews.isEmpty ? 1 : reviews.length));
  }

  void updateReview(String productId, reviewData) {
    // debugPrint('update user review called');
    if (_reviews.containsKey(productId)) {
      final reviewIndex = getUserReviewIndexonProduct(productId);
      if (reviewIndex >= 0) {
        _reviews[productId][reviewIndex] = ReviewRatingItemModel(
          reviewId: reviewData['reviewId'],
          userId: reviewData['userId'],
          rating: int.parse(reviewData['rating']),
          reviewMessage: reviewData['message'],
        );

        try {
          ReviewHelper.addReviewsInFirestore(
            {
              ...reviewData,
              'productId': productId,
            },
            isUpdate: true,
            reviewId: reviewData['reviewId'],
          );
        } catch (error) {
          debugPrint('error in saving review data ${error.toString()}');
        }
        _notificationProvider?.addNotification(
          NotificationItemModel(
            text: reviewNotification['t2']!['text']!,
            id: DateTime.now().toString(),
            title: reviewNotification['t2']!['title']!,
            icon: Icons.comment_bank_rounded,
            action: {
              'action': 'review',
              'params': productId,
            },
          ),
        );
        notifyListeners();
        // debugPrint(reviewData.toString());
      }
    }
  }
}
