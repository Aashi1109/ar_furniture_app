import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../helpers/firebase/profile_helper.dart';
import '../../helpers/material_helper.dart';
import '../../helpers/modal_helper.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/auth/auth_form.dart';

class UserAccountEditScreen extends StatefulWidget {
  const UserAccountEditScreen({super.key});
  static const namedRoute = '/user-account-edit';

  @override
  State<UserAccountEditScreen> createState() => _UserAccountEditScreenState();
}

class _UserAccountEditScreenState extends State<UserAccountEditScreen> {
  late bool canChangePass;
  late User curUser;
  _getFormData(Map<String, dynamic> formData, String type) async {
    // debugPrint(formData.toString());
    setState(() {
      _isLoading = true;
    });

// This will check if user can change password or not

// Update the user's password.
    try {
      if (curUser != null) {
        if (canChangePass) {
          final currentUserCredential = EmailAuthProvider.credential(
              email: curUser.email!, password: formData['prevPassword']);
          await curUser.reauthenticateWithCredential(currentUserCredential);

          await curUser.updatePassword(formData['password']);
          // .then((_)  {
          //   debugPrint("Password updated successfully!");
          // }).catchError((error) {
          //   debugPrint("Error updating password: $error");
          // });
        }
        Map<String, String> userNewData = {
          'name': formData['name'],
        };
        // ignore: use_build_context_synchronously
        ModalHelpers.createInfoSnackbar(
          context,
          'Account Info Updated Successfully',
        );
        if ((formData['image'] as String).isNotEmpty) {
          await ProfileHelper.saveUserDataInFirestore(
            imgPath: formData['image'],
            name: userNewData['name']!,
            isUpdate: true,
          );
        }
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
  void initState() {
    final auth = FirebaseAuth.instance;
    final curUser = auth.currentUser;
    // bool canUserChangePass = false;

    if (curUser != null) {
      List<UserInfo> providerData = curUser.providerData;
      canChangePass = false;
      for (var userInfo in providerData) {
        // debugPrint(userInfo.providerId.toString());
        if (userInfo.providerId == 'password') {
          canChangePass = true;
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProviderModel>(
      context,
      listen: false,
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
              canChangePass: canChangePass,
            ),
          ],
        ),
      ),
    );
  }
}
