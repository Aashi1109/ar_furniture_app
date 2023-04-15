import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/general_provider.dart';
import '../../screens/product/product_detail_screen.dart';

class ScreenshotsItem extends StatelessWidget {
  const ScreenshotsItem({
    super.key,
    required this.ssId,
    required this.productId,
    required this.imageUrl,
  });
  final String ssId;
  final String productId;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final themeColorScheme = Theme.of(context).colorScheme;
    final generalProvider = Provider.of<GeneralProviderModel>(
      context,
      listen: false,
    );
    return Container(
      decoration: BoxDecoration(
        // color: Colors.amber,
        borderRadius: BorderRadius.circular(
          10,
        ),
        border: Border.all(
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          8,
        ),
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: themeColorScheme.primary,
            leading: IconButton(
              icon: Icon(
                Icons.remove_red_eye_rounded,
                color: themeColorScheme.onPrimary,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  ProductDetailScreen.namedRoute,
                  arguments: productId,
                );
              },
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.delete_rounded,
                color: themeColorScheme.onPrimary,
              ),
              onPressed: () {
                generalProvider.deleteScreenshot(ssId);
              },
            ),
          ),
          child: FadeInImage(
            image: NetworkImage(imageUrl),
            placeholder: const AssetImage('assets/images/defaults/ss.jpg'),
            fit: BoxFit.cover,
            imageErrorBuilder: (context, error, stackTrace) => Image.asset(
              'assets/images/defaults/ss_not_found.png',
            ),
          ),
        ),
      ),
    );
  }
}
