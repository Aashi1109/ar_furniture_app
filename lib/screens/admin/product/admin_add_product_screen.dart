import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../helpers/material_helper.dart';
import 'new/add_product_form.dart';

class AdminAddProductScreen extends StatelessWidget {
  const AdminAddProductScreen({
    super.key,
  });

  static const namedRoute = '/add-product';

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    String? productId;
    if (routeArgs != null) {
      productId = routeArgs as String;
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(
            kDefaultPadding,
          ),
          child: Column(
            children: [
              MaterialHelper.buildCustomAppbar(
                context,
                productId != null ? "Update Product" : 'Add Product',
              ),
              const SizedBox(
                height: 10,
              ),

              // ),
              AddProductForm(
                isUpdateForm: (productId == null) ? false : true,
                productId: productId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
