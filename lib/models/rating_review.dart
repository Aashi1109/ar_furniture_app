class ReviewRatingItemModel {
  final int rating;
  final String reviewMessage;
  final String reviewId;
  final String userId;
  // final String productId;

  ReviewRatingItemModel({
    required this.reviewId,
    required this.userId,
    required this.rating,
    required this.reviewMessage,
    // required this.productId,
  });
}
