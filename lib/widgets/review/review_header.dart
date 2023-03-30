import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ReviewRatingHeader extends StatelessWidget {
  const ReviewRatingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '4.3',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('32 ratings'),
          ],
        ),
        Expanded(
          child: Column(
            children: [1, 2, 3, 4, 5].map(
              (e) {
                return Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ...List.generate(
                      6 - e,
                      (index) => const Icon(
                        Icons.star_rounded,
                        size: 20,
                      ),
                    ),
                    Text(
                      '12',
                      style: TextStyle(
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
