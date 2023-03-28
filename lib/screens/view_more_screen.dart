import 'package:decal/helpers/material_helper.dart';
import 'package:decal/providers/products_provider.dart';
import 'package:decal/widgets/filters/filters.dart';
import '../widgets/products_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewMoreScreen extends StatefulWidget {
  const ViewMoreScreen({super.key});
  static const namedRoute = '/view-more';

  @override
  State<ViewMoreScreen> createState() => _ViewMoreScreenState();
}

class _ViewMoreScreenState extends State<ViewMoreScreen> {
  String? _newFilter;
  @override
  Widget build(BuildContext context) {
    final routeCategory = ModalRoute.of(context)?.settings.arguments as String;
    final productProvider =
        Provider.of<ProductProviderModel>(context, listen: false);
    // final products = productProvider.products;
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10,
        ),
        child: Column(
          children: [
            MaterialHelper.buildCustomAppbar(context, 'View More', () {}),
            FilterHorizontal((val) {
              debugPrint(val);
              setState(() {
                _newFilter = val.toLowerCase();
              });
            }, routeCategory),
            ProductGridView(
              productProvider
                  .getProductsByCategory(_newFilter ?? routeCategory),
              mediaQuery,
            ),
          ],
        ),
      ),
    );
  }
}
