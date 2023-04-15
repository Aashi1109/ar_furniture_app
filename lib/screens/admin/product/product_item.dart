import 'package:decal/helpers/general_helper.dart';
import 'package:decal/helpers/modal_helper.dart';
import 'package:decal/providers/products_provider.dart';
import 'package:decal/screens/admin/product/admin_add_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    super.key,
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
  });
  final String id;
  final String title;
  final double price;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final themeColorScheme = Theme.of(context).colorScheme;
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<ProductProviderModel>(
          context,
          listen: false,
        ).removeProductById(
          id,
        );
      },
      confirmDismiss: (direction) {
        return ModalHelpers.confirmUserChoiceDialog(
          context,
          'Delete Product',
          'This product will be deleted permanetly',
        );
      },
      background: Container(
        padding: const EdgeInsets.only(
          right: 40,
        ),
        alignment: Alignment.centerRight,
        color: themeColorScheme.error,
        child: Icon(
          Icons.delete_rounded,
          color: themeColorScheme.onPrimary,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: FadeInImage(
          image: NetworkImage(
            GeneralHelper.genReducedImageUrl(
              imageUrl,
              params: [
                'w_60',
              ],
            ),
          ),
          placeholder: const AssetImage(
            'assets/images/defaults/product.jpeg',
          ),
          height: 40,
          width: 40,
          fit: BoxFit.contain,
        ),
        title: Text(
          title,
        ),
        subtitle: Text(
          'Price: \$${GeneralHelper.removeZerosFromPrice(
            price,
          )}',
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.edit_rounded,
            color: themeColorScheme.primary,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(
              AdminAddProductScreen.namedRoute,
              arguments: id,
            );
          },
        ),
      ),
    );
  }
}
