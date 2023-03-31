import 'dart:math';

import 'package:flutter/material.dart';

class ReviewRatingBar extends StatelessWidget {
  const ReviewRatingBar(this.maxValue, this.rating, {super.key});
  final int maxValue;
  final int rating;

  @override
  Widget build(BuildContext context) {
    // debugPrint('max value ${maxValue.toString()}');
    // debugPrint('rating ${rating.toString()}');
    return Expanded(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * .3,
        ),
        height: 12,
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            // widthFactor: .125,
            widthFactor: (rating == 0 && maxValue == 0)
                ? .1
                : max(.1, rating / maxValue),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
