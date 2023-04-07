import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/material_helper.dart';
import '../providers/products_provider.dart';
import '../widgets/products_grid_view.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});
  static const namedRoute = '/favourites';

  @override
  Widget build(BuildContext context) {
    final isPagePushed = Navigator.of(context).canPop();

    final mediaQuery = MediaQuery.of(context);
    final products =
        Provider.of<ProductProviderModel>(context, listen: false).products;
    final favProducts = products
        .where(
          (prod) => prod.isFavourite == true,
        )
        .toList();
    debugPrint(products.length.toString());
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: isPagePushed ? 30 : 50,
          left: 10,
          right: 10,
          bottom: 20,
        ),
        child: Column(
          children: [
            if (isPagePushed)
              MaterialHelper.buildCustomAppbar(
                context,
                'Favourites',
              ),
            if (!isPagePushed)
              Row(
                children: [
                  const Spacer(),
                  Text(
                    'Favourites',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const Spacer(),
                ],
              ),
            const SizedBox(
              height: 10,
            ),
            ProductGridView(
              favProducts,
              mediaQuery,
            ),
          ],
        ),
      ),
    );
  }
}
