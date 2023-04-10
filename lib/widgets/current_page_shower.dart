import 'package:flutter/material.dart';

class BottomPageShower extends StatelessWidget {
  const BottomPageShower({
    super.key,
    required this.currentIndex,
    this.circleCount = 4,
    this.cirleSize = 30,
  });
  final int currentIndex;
  final int circleCount;
  final double cirleSize;

  Widget buildCircles(String textToShowOnCirlce, bool isSelected,
      ColorScheme themeColorScheme) {
    return Container(
      margin: const EdgeInsets.only(
        right: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          100,
        ),
        border: Border.all(
          color: isSelected ? themeColorScheme.primary : Colors.grey,
          width: 2,
        ),
      ),
      height: cirleSize,
      width: cirleSize,
      child: Center(
        child: Text(
          textToShowOnCirlce,
          style: TextStyle(
            color: isSelected ? themeColorScheme.primary : Colors.grey,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final currentIndex = 2;
    final themeColorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(circleCount, (index) => index).map(
        (e) {
          return buildCircles(
            '${e + 1}',
            currentIndex == e + 1,
            themeColorScheme,
          );
        },
      ).toList(),
    );
  }
}
