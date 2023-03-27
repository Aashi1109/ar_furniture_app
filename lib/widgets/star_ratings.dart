import 'package:flutter/material.dart';

class StarRatings extends StatelessWidget {
  const StarRatings(this.rating, this.ratingCount, {super.key, this.scale = 5});
  final double rating;
  final int ratingCount;
  final int scale;

  List<String> _generateRateArray() {
    List<String> rateArray = [];
    double tempRate = rating;
    int counter = 0;

    while (counter != scale) {
      if (tempRate >= 1) {
        tempRate--;
        rateArray.add('f');
      } else if (tempRate > 0.0 && tempRate < 1.0) {
        rateArray.add('h');
        tempRate--;
      } else if (tempRate <= 0) {
        rateArray.add('e');
      }
      debugPrint(tempRate.toString());
      counter++;
    }

    return rateArray;
  }

  @override
  Widget build(BuildContext context) {
    final rateArray = _generateRateArray();
    debugPrint(rateArray.toString());
    debugPrint(scale.toString());
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 62,
      // width: MediaQuery.of(context).size.width * .35,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: rateArray.map((e) {
                  if (e == 'f') {
                    return const Icon(Icons.star_rounded);
                  }
                  if (e == 'h') {
                    return const Icon(Icons.star_half_rounded);
                  }
                  // if (e == 'e') {
                  return const Icon(Icons.star_outline_rounded);
                  // }
                  // return const SizedBox.square(
                  //   dimension: 0,
                  // );
                }).toList(),
              ),
            ),
            IntrinsicHeight(
              child: Row(
                children: [
                  Text(rating.toStringAsFixed(1)),
                  VerticalDivider(
                    thickness: 1,
                  ),
                  Text('$ratingCount ratings')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
