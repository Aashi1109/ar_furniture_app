import 'package:flutter/material.dart';

class Description extends StatefulWidget {
  Description(
    this.description, {
    super.key,
    this.bgColor,
    this.title = 'Description',
  });
  final String description;
  final String title;
  Color? bgColor;

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  bool _isExpanded = false;
  _clickHandler() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint(
    //     'description text length ${widget.description.length.toString()}');
    widget.bgColor ??= Theme.of(context).colorScheme.tertiary;

    return Container(
      // constraints: BoxConstraints(
      //   maxHeight:
      // ),
      // height: _isExpanded ? null : 50,
      // height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.bgColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            Text(
              widget.description,
              overflow:
                  _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              // softWrap: false,
              maxLines:
                  _isExpanded ? null : (widget.description.length > 35 ? 4 : 1),
            ),
            if (widget.description.length > 35)
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: _clickHandler,
                  child: Text(
                    'Show ${_isExpanded ? 'less' : 'more'} >>',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
