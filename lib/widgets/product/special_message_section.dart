import 'package:flutter/material.dart';

import '../../constants.dart';

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
              top: 0,
              left: 0,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                ),
                padding: const EdgeInsets.only(
                  left: 40,
                  top: 20,
                ),
                width: MediaQuery.of(context).size.width - 2 * kDefaultPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '5% discount',
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
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
              ),
            )
          ],
        )
      ],
    );
  }
}
