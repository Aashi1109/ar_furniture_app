import 'package:decal/widgets/bottom_tabbar.dart';
import 'package:decal/widgets/filters/filters.dart';
import 'package:decal/widgets/furniture_item.dart';
import 'package:decal/widgets/product_vertical_view.dart';
import 'package:decal/widgets/search_filter.dart';
import 'package:flutter/material.dart';
import '../widgets/special_message_section.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});
  static const namedRoute = '/catalog';

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catalog'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              // FilterHorizontal((String val) {
              //   debugPrint(val);
              // }),
              // SearchFilter(),
              // VerticalSection(),
              SpecialSection(),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomTabBar(),
    );
  }
}
