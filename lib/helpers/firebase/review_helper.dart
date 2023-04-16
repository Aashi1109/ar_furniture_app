import 'package:cloud_firestore/cloud_firestore.dart';


/// It holds all the methods to add, delete and update review data in
/// firestore. review data is stored in `review` collection.
/// The Structure of how review's data is stored in firestore
/// `[reviews > reviewId >  reviewData]`.
/// No error handling is done is here it should be handled where you are using
/// it.
class ReviewHelper {
  static const reviewsCollectionPath = 'reviews';

  /// Returns reviews collection
  static CollectionReference<Map<String, dynamic>> getReviewsCollection() {
    final reviewsCollection =
        FirebaseFirestore.instance.collection(reviewsCollectionPath);

    return reviewsCollection;
  }

  /// To add or update a review in firestore. [review] contains key [productId],
  /// [userId],[rating] and [message]. [isUpdate] and [reviewId] is used when we
  /// are updating a review. In this case, whole data is overwritten with [review].
  static Future<void> addReviewsInFirestore(Map<String, dynamic> review,
      {isUpdate = false, String? reviewId}) {
    final reviewsCollection = getReviewsCollection();
    if (isUpdate) {
      // debugPrint('reviewData from helper $review');
      return reviewsCollection.doc(reviewId).set(review);
    }
    return reviewsCollection.add(
      review,
    );
  }

  /// Returns all reviews from reviews collection.
  static Future<QuerySnapshot<Map<String, dynamic>>> getReviewsFromFirestore() {
    final reviewsCollection = getReviewsCollection();
    return reviewsCollection.get();
  }
}
