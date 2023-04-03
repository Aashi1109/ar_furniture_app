import '../helpers/firebase/review_helper.dart';
import '../helpers/firebase_helper.dart';
import '../models/rating_review.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReviewRatingProviderModel extends ChangeNotifier {
  Map<String, dynamic> _reviews = {};

  Map<String, List<ReviewRatingItemModel>> get reviews {
    return {..._reviews};
  }

  int getUserReviewIndexonProduct(String productId) {
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
    if (_reviews.containsKey(productId)) {
      return [..._reviews[productId]];
    }
    return [];
  }

  void moveUserReviewOnTop() {
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

  void addReview(String productId, Map<String, String> reviewData,
      {bool isDataSet = false}) {
    // debugPrint(reviewData.toString());
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
    debugPrint('in review fetch');
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
    } catch (error) {
      debugPrint('error in getting product reviews ${error.toString()}');
    }
  }

  double getAverageRatingForProduct(String productId) {
    final reviews = getReviewsForProduct(productId);
    final totalReview = reviews.fold(
        0, (previousValue, element) => previousValue + element.rating);
    return (totalReview / (reviews.isEmpty ? 1 : reviews.length));
  }

  void updateReview(String productId, reviewData) {
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
        notifyListeners();
        // debugPrint(reviewData.toString());
      }
    }
  }
}
