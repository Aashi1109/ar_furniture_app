import 'package:flutter/material.dart';

class FilterHorizontal extends StatefulWidget {
  final Function setChosenFilter;
  const FilterHorizontal(this.setChosenFilter, this.selectedCat, {super.key});
  final String selectedCat;

  @override
  State<FilterHorizontal> createState() => _FilterVertState();
}

class _FilterVertState extends State<FilterHorizontal> {
  late List filterArray;
  int? _selectedIndex;
  _filterTapHandler(int curIndex) {
    setState(() {
      _selectedIndex = curIndex;
    });
    // debugPrint(Theme.of(context).colorScheme.primary.toString());
    // debugPrint(
    //     MaterialHelper.createMaterialColor(Color(0x00030A4E)).toString());
    widget.setChosenFilter(filterArray[_selectedIndex!]);
  }

  @override
  void initState() {
    filterArray = ['All', 'Chair', 'Sofa', 'Vase', 'Wallart', 'Furniture'];
    final selectedCatIndex = filterArray
        .indexWhere((element) => element.toLowerCase() == widget.selectedCat);
    if (selectedCatIndex >= 0) {
      _selectedIndex = selectedCatIndex;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 20,
      ),
      height: 38,
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) => InkWell(
          onTap: () => _filterTapHandler(index),
          child: Container(
            margin: const EdgeInsets.only(
              right: 15,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 7,
              horizontal: 15,
            ),
            // height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: _selectedIndex == index
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.tertiary,
              // color: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              filterArray[index],
              style: TextStyle(
                color: _selectedIndex == index
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        scrollDirection: Axis.horizontal,
        itemCount: filterArray.length,
      ),
    );
  }
}
