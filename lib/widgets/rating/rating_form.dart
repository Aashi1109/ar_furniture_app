import 'package:decal/helpers/material_helper.dart';
import 'package:decal/providers/rating_review_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'rating_stars_form.dart';
import '../../constants.dart';

class ReviewRatingForm extends StatelessWidget {
  ReviewRatingForm(this.id, {super.key});
  final String id;
  final userId = FirebaseAuth.instance.currentUser?.uid;
  int? _selectedRating;
  String? _enteredReview;
  final _formKey = GlobalKey<FormState>();
  // final _enteredReviewController = TextEditingController();

  void _getRating(int rating) {
    _selectedRating = rating;
  }

  void _submitHandler(BuildContext context) {
    final isFormValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (isFormValid!) {
      _formKey.currentState?.save();
      Provider.of<ReviewRatingProviderModel>(
        context,
        listen: false,
      ).addReview(id, {
        'rating': _selectedRating.toString(),
        'message': _enteredReview!,
        'userId': userId!,
      });
      Navigator.of(context).pop();
      // debugPrint(_selectedRating.toString());
      // // debugPrint(_enteredReviewController.text);
      // debugPrint(_enteredReview);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: kDefaultPadding,
        top: kDefaultPadding,
        left: kDefaultPadding,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Write a review',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          RatingStarsForm(_getRating),
          const SizedBox(
            height: 10,
          ),
          Form(
            key: _formKey,
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Your review',
                border: OutlineInputBorder(),
              ),
              minLines: 5,
              maxLines: 8,
              onSaved: (newValue) {
                _enteredReview = newValue?.trim();
              },
              // controller: _enteredReviewController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Provide a valid review';
                }
                if (value.length < 10) {
                  return 'Review should be 10 characters long';
                }
                return null;
              },
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          MaterialHelper.buildLargeElevatedButton(
            context,
            'Post Review',
            () => _submitHandler(context),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
