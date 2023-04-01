import 'package:flutter/material.dart';

class OnboardItem extends StatelessWidget {
  final String text;
  final String imageUrl;
  const OnboardItem(this.imageUrl, this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: .8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imageUrl,
            // color: Colors.amber,
            height: 350,
            width: double.infinity,
            fit: BoxFit.contain,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
            // softWrap: true,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
