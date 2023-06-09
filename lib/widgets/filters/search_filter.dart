import 'package:flutter/material.dart';

class SearchFilter extends StatelessWidget {
  final Function setSearchFilterQuery;
  const SearchFilter(this.setSearchFilterQuery, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Search',
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.tertiary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 10,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            onTapOutside: (value) {
              FocusScope.of(context).unfocus();
            },
            onChanged: (val) {
              setSearchFilterQuery(val.trim());
            },
          ),
        ),
        // IconButton(
        //   onPressed: () {},
        //   icon: Icon(
        //     Icons.tune_rounded,
        //     color: Theme.of(context).colorScheme.primary,
        //   ),
        // ),
      ],
    );
  }
}
