import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/general_provider.dart';
import 'screenshots_item.dart';

class ScreenshotsGridview extends StatelessWidget {
  const ScreenshotsGridview({super.key});

  @override
  Widget build(BuildContext context) {
    final screenshots = Provider.of<GeneralProviderModel>(context).screenshots;
    // final screenshots = [2, 3];
    return Expanded(
      child: screenshots.isEmpty
          ? const Center(
              child: Text('No screenshots found'),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .5,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemBuilder: (context, index) {
                return ScreenshotsItem(
                  ssId: screenshots[index].id,
                  productId: screenshots[index].productId,
                  imageUrl: screenshots[index].imageUrl,
                );
              },
              itemCount: screenshots.length,
              padding: EdgeInsets.zero,
            ),
    );
  }
}
