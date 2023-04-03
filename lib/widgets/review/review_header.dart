import 'review_rating_bar.dart';
import 'package:flutter/material.dart';

class ReviewRatingHeader extends StatelessWidget {
  const ReviewRatingHeader({
    super.key,
    required this.rateData,
    required this.maxNoOfRating,
    required this.totalNoOfRatings,
    required this.averageRating,
  });
  final Map<int, int> rateData;
  final int maxNoOfRating;
  final int totalNoOfRatings;
  final double averageRating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              averageRating.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('$totalNoOfRatings ratings'),
          ],
        ),
        Expanded(
          child: Column(
            children: [1, 2, 3, 4, 5].map(
              (e) {
                return Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: List.generate(
                          6 - e,
                          (index) => const Icon(
                            Icons.star_rounded,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    ReviewRatingBar(
                      maxNoOfRating,
                      rateData[6 - e]!,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      rateData[6 - e]!.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                );
              },
            ).toList(),
          ),
        ),
        //
      ],
    );
  }
}
