import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'notification_provider.dart';
import '../constants.dart';
import '../helpers/general_helper.dart';
import '../helpers/firebase/review_helper.dart';
import '../models/rating_review.dart';

/// Contains all the methods and properties related to
/// reviews and ratings for all prodcuts.
/// it has a setter [notificationProvider] which sets
/// notification provider allow to access notifications
/// class methods to add new notifications as required.
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

  /// This methods returns the index of review placed on product
  /// by certains user no need to provide [userId] as it itself
  /// access it using [FirebaseAuth.instance.currentUser.uid]
  ///
  /// This method can be helpful if you want to know if user has
  /// already reviewed on some product or not.
  /// If no reviews is found it returns -1
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

  /// Returns all the reviews for a certain product using [productId]
  List<ReviewRatingItemModel> getReviewsForProduct(
    String productId,
  ) {
    // debugPrint('get review for product called');
    if (_reviews.containsKey(productId)) {
      return [..._reviews[productId]];
    }
    return [];
  }

  /// Moves all the reviews placed by the [currentUser] on products.
  /// Internally uses [getUserReviewIndexonProduct] method to find
  /// their reviews and place it on top
  ///
  /// Use this method only if small number of reviews are there
  /// Otherwise use it when providing reviews for certain products
  /// Does not call `notifyListeners()`
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

  /// This method add new product in the private variable [_reviews] which
  /// holds all the reviews for the whole app
  /// [isDataSet] is used as a flag so that while using this method to
  /// initalize data it won't resend it to the server because whenever we add
  /// new reviews using this method we directly send it to server to store it.
  /// [reviewData] consists of keys [reviewId], [rating], [userId] and
  /// [reviewMessage]
  /// Also creates a new notification whenever a new review is made using
  /// [_notificationProvider]'s [addNotification()] method.
  void addReview(
    String productId,
    Map<String, String> reviewData, {
    bool isDataSet = false,
  }) async {
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

    if (!isDataSet) {
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

      try {
        await ReviewHelper.addReviewsInFirestore(
          {
            ...reviewData,
            'productId': isDataSet ? reviewData['productId'] : productId,
          },
        );
        await getAndSetReviews(
          isUpdate: true,
        );
      } catch (error) {
        debugPrint('error in saving review data ${error.toString()}');
      }
      notifyListeners();
    }
  }

  /// Intialize the global reviews data for the app
  /// uses [_isReviewDataInit] so that data is initilized only once because
  /// we are calling it on different number of places.
  /// Internally uses [addReview()] and [moveUserReviewOnTop()]
  Future<void> getAndSetReviews({bool isUpdate = false}) async {
    // debugPrint('get and set review called');
    return GeneralHelper.getAndSetWrapper(_isReviewDataInit || isUpdate,
        () async {
      try {
        final reviewData = await ReviewHelper.getReviewsFromFirestore();
        // debugPrint(reviewData.docs.toString());
        if (isUpdate) {
          _reviews = {};
        }

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
  }

  /// Returns average rating for a product.
  /// Returns zero if not review is there.
  double getAverageRatingForProduct(String productId) {
    // debugPrint('get average rating review called');
    final reviews = getReviewsForProduct(productId);
    final totalReview = reviews.fold(
        0, (previousValue, element) => previousValue + element.rating);
    return (totalReview / (reviews.isEmpty ? 1 : reviews.length));
  }

  /// Update a certain review placed by user
  /// Uses [getUserReviewIndexonProduct()] to find and update it. It also
  /// updates it in the cloud too and generates notification for the same.
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
          // debugPrint('data from provider ${reviewData['reviewId']}');
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
