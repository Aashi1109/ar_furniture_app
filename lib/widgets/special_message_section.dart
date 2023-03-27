import 'package:flutter/material.dart';

class SpecialSection extends StatelessWidget {
  const SpecialSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Special Offer just for you',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(
          height: 15,
        ),
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                // opacity: ,
                'assets/images/sofa.png',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                // color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            Positioned(
              top: 20,
              left: 30,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '5% discount',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'For a cozy yellow set.',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Learn More',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
