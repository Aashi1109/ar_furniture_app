import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewHelper {
  static const reviewsCollectionPath = 'reviews';

  static CollectionReference<Map<String, dynamic>> getReviewsCollection() {
    final reviewsCollection =
        FirebaseFirestore.instance.collection(reviewsCollectionPath);

    return reviewsCollection;
  }

  static Future<void> addReviewsInFirestore(Map<String, dynamic> review,
      {isUpdate = false, String? reviewId}) {
    final reviewsCollection = getReviewsCollection();
    if (isUpdate) {
      return reviewsCollection.doc(reviewId).set(review);
    }
    return reviewsCollection.add(
      review,
    );
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getReviewsFromFirestore() {
    final reviewsCollection = getReviewsCollection();
    return reviewsCollection.get();
  }
}
