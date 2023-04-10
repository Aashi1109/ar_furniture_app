import 'dart:io';

import '../constants.dart';
import '../helpers/firebase/profile_helper.dart';

import '../helpers/material_helper.dart';
import '../helpers/modal_helper.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAccountEditScreen extends StatefulWidget {
  const UserAccountEditScreen({super.key});
  static const namedRoute = '/user-account-edit';

  @override
  State<UserAccountEditScreen> createState() => _UserAccountEditScreenState();
}

class _UserAccountEditScreenState extends State<UserAccountEditScreen> {
  _getFormData(Map<String, dynamic> formData, String type) async {
    debugPrint(formData.toString());
    setState(() {
      _isLoading = true;
    });

// Get the current user.
    final User? user = FirebaseAuth.instance.currentUser;

// Update the user's password.
    try {
      if (user != null) {
        final currentUserCredential = EmailAuthProvider.credential(
            email: user.email!, password: formData['prevPassword']);
        await user.reauthenticateWithCredential(currentUserCredential);
        user.updatePassword(formData['password']).then((_) async {
          Map<String, String> userNewData = {
            'name': formData['name'],
          };
          ModalHelpers.createInfoSnackbar(
              context, 'Account Info Updated Successfully');
          if ((formData['image'] as String).isNotEmpty) {
            await ProfileHelper.saveUserDataInFirestore(
              imgPath: formData['image'],
              name: userNewData['name']!,
              isUpdate: true,
            );
          }

          debugPrint("Password updated successfully!");
        }).catchError((error) {
          debugPrint("Error updating password: $error");
        });
      }
      await Provider.of<AuthProviderModel>(context, listen: false)
          .getAndSetAuthData(isUpdate: true);
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (error) {
      ModalHelpers.createAlertDialog(
        context,
        error.code.toUpperCase().split('-').join(' '),
        error.message.toString(),
      );
    } catch (error) {
      ModalHelpers.createAlertDialog(
        context,
        'Something wrong happened',
        error.toString(),
      );
      debugPrint('Something wrong happened ${error.toString()}');
    }

    setState(() {
      _isLoading = false;
    });
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProviderModel>(
      context,
    );
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: kDefaultPadding,
          right: kDefaultPadding,
          top: kDefaultPadding + 10,
          left: kDefaultPadding,
        ),
        child: Column(
          children: [
            MaterialHelper.buildCustomAppbar(context, 'Account Info Edit'),
            const SizedBox(
              height: 10,
            ),
            AuthForm(
              _getFormData,
              _isLoading,
              isEditForm: true,
              editData: {
                'imageUrl': authProvider.userImageUrl,
                'name': authProvider.userName,
              },
            ),
          ],
        ),
      ),
    );
  }
}
