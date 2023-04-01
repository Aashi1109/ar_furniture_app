import 'package:flutter/material.dart';

class RatingStarsForm extends StatefulWidget {
  const RatingStarsForm(this.setRating, {super.key, this.prevRating});
  final Function setRating;
  final int? prevRating;

  @override
  State<RatingStarsForm> createState() => _RatingStarsFormState();
}

class _RatingStarsFormState extends State<RatingStarsForm> {
  int? _selectedRating;
  _handleRating(int rating) {
    setState(() {
      _selectedRating = rating;
      widget.setRating(_selectedRating);
    });
  }

  @override
  void initState() {
    _selectedRating = widget.prevRating;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [1, 2, 3, 4, 5]
          .map(
            (e) => IconButton(
              onPressed: () => _handleRating(e),
              icon: Icon(
                (_selectedRating != null) && (_selectedRating! >= e)
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          )
          .toList(),
    );
  }
}
