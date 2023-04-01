import 'package:decal/helpers/material_helper.dart';
import 'package:decal/helpers/modal_helper.dart';
import 'package:decal/providers/rating_review_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'review_stars_form.dart';
import '../../constants.dart';

class ReviewRatingForm extends StatelessWidget {
  ReviewRatingForm(this.id, {super.key, this.isEditForm = false});
  final String id;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  final bool isEditForm;
  final _formKey = GlobalKey<FormState>();
  // final _enteredReviewController = TextEditingController();

  Map<String, String> _reviewData = {
    'rating': '',
    'message': '',
    'userId': '',
  };
  void _getRating(int rating) {
    _reviewData['rating'] = rating.toString();
  }

  void _submitHandler(BuildContext context) {
    final isFormValid = _formKey.currentState?.validate();
    final reviewprovider = Provider.of<ReviewRatingProviderModel>(
      context,
      listen: false,
    );
    FocusScope.of(context).unfocus();
    _reviewData['userId'] = userId ?? '';

    if (isFormValid!) {
      _formKey.currentState?.save();
      if (isEditForm) {
        reviewprovider.updateReview(id, _reviewData);
        ModalHelpers.createInfoSnackbar(context, 'Review Updated Successfully');
      } else {
        reviewprovider.addReview(id, _reviewData);
        ModalHelpers.createInfoSnackbar(context, 'Review Added');
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isEditForm) {
      final index = Provider.of<ReviewRatingProviderModel>(
        context,
        listen: false,
      ).getUserReviewIndexonProduct(id);
      if (index >= 0) {
        final reviewData = Provider.of<ReviewRatingProviderModel>(
          context,
          listen: false,
        ).reviews[id]?[index];

        // debugPrint(reviewData.toString());
        _reviewData['rating'] = (reviewData?.rating).toString();
        _reviewData['message'] = (reviewData?.reviewMessage as String);
        _reviewData['reviewId'] = (reviewData?.reviewId as String);

        // debugPrint(_reviewData.toString());
      }
    }
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
            isEditForm ? 'Edit Review' : 'Write a review',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          RatingStarsForm(
            _getRating,
            prevRating: isEditForm ? int.parse(_reviewData['rating']!) : null,
          ),
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
              initialValue: _reviewData['message'],
              onSaved: (newValue) {
                _reviewData['message'] = newValue?.trim() ?? '';
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
            isEditForm ? 'Update Review' : 'Post Review',
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
