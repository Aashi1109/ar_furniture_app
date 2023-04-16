import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/products_provider.dart';
import 'product_item.dart';
import 'admin_add_product_screen.dart';
import '../../../constants.dart';
import '../../../helpers/material_helper.dart';

class AdminProductScreen extends StatelessWidget {
  const AdminProductScreen({super.key});
  static const namedRoute = 'admin-product-screen';

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProviderModel>(context);
    final products = productProvider.products;
    return RefreshIndicator(
      onRefresh: () => productProvider.getAndSetProducts(
        isUpdate: true,
      ),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(
            kDefaultPadding,
          ),
          child: Column(
            children: [
              MaterialHelper.buildCustomAppbar(
                context,
                'Products',
                action: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      AdminAddProductScreen.namedRoute,
                    );
                  },
                  icon: const Icon(
                    Icons.add_rounded,
                    size: 32,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return ProductItem(
                      id: products[index].id,
                      title: products[index].title,
                      price: products[index].price,
                      imageUrl: products[index].images['main'],
                    );
                  },
                  itemCount: products.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
