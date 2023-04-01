import 'package:decal/helpers/modal_helper.dart';
import 'package:decal/providers/cart_provider.dart';
import 'package:decal/providers/products_provider.dart';
import 'package:decal/screens/view_ar_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailBottomTabbar extends StatelessWidget {
  const ProductDetailBottomTabbar(this.id, {super.key});
  final String id;

  @override
  Widget build(BuildContext context) {
    final foundProduct =
        Provider.of<ProductProviderModel>(context, listen: false)
            .getProductById(id);
    return SizedBox(
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(ViewARScreen.namedRoute, arguments: id);
            },
            style: OutlinedButton.styleFrom(minimumSize: const Size(130, 45)),
            child: const Text(
              'View in AR',
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<CartProviderModel>(context, listen: false)
                  .addItemToCart(
                prodId: id,
                title: foundProduct.title,
                price: foundProduct.price,
                quantity: 1,
                imageUrl: foundProduct.images['main'],
              );

              ModalHelpers.createInfoSnackbar(context, 'Product Added to cart');
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size(130, 45)),
            child: const Text('Add to cart'),
          ),
        ],
      ),
    );
  }
}
