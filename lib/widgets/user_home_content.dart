import '../providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'product_vertical_view.dart';
import 'search_filter.dart';
import 'products_grid_view.dart';
import 'package:provider/provider.dart';

class UserHomeContent extends StatefulWidget {
  const UserHomeContent({super.key});

  @override
  State<UserHomeContent> createState() => _UserHomeContentState();
}

class _UserHomeContentState extends State<UserHomeContent> {
  bool _isFilteringOn = false;
  String? _filterValue;
  // bool _reset = false;

  void _getCurrentSelectedFilter(String filter) {
    setState(() {
      _filterValue = filter.toLowerCase();
      _isFilteringOn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProviderModel>(context, listen: false);
    final mediaQuery = MediaQuery.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // FiltersIcon(_getCurrentSelectedFilter),
        const SizedBox(
          height: 10,
        ),
        SearchFilter(_getCurrentSelectedFilter),
        if (!_isFilteringOn) ...[
          const SizedBox(
            height: 15,
          ),
          VerticalSection('New Arrival of Chairs', 'chair'),
          const SizedBox(
            height: 15,
          ),
          VerticalSection('Trending Furnitures', 'furniture'),
          const SizedBox(
            height: 15,
          ),
          VerticalSection(
            'Decors for home',
            'decor',
          ),
        ],
        if (_isFilteringOn) ...[
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Search results :',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isFilteringOn = false;
                    _filterValue = null;
                    // _reset = true;
                  });
                },
                icon: const Icon(Icons.close_rounded),
                label: const Text('Clear'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
        // if(_isFilteringOn && _filterValue == '') ,
        if (_isFilteringOn)
          Container(
            constraints: BoxConstraints(
              // minHeight: mediaQuery.size.height * .3,
              maxHeight: mediaQuery.size.height * .55,
            ),
            child: _filterValue == ''
                ? const Center(
                    child: Text('Nothing to search'),
                  )
                : ProductGridView(
                    productProvider.getProductsByQuery(_filterValue!),
                    mediaQuery,
                  ),
          ),
      ],
    );
  }
}
