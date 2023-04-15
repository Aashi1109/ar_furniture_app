import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../helpers/authentication_helper.dart';
import '../../helpers/firebase/profile_helper.dart';
import '../../helpers/firebase_helper.dart';
import '../../helpers/modal_helper.dart';
import '../../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  static const namedRoute = '/auth-screen';
  const AuthScreen({super.key, this.authType = 'login'});
  final String authType;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;

  void _getFormData(
    formData,
    String authType,
  ) async {
    FirebaseAuth auth = FirebaseAuth.instance; // _auth = FirebaseAuth.instance;

    UserCredential userCredential;
    setState(() {
      _isLoading = true;
    });
    try {
      if (formData['handler'] != null) {
        if (formData['handler'] == 'google') {
          userCredential = await auth.signInWithCredential(
            await AuthenticationHelper.authWithGoogle(),
          );
          if (userCredential.additionalUserInfo?.isNewUser == true) {
            await ProfileHelper.saveUserDataInFirestore(
              imageUrl: userCredential.user?.photoURL ?? '',
              name: userCredential.user?.displayName,
            );
          }
        }
      } else {
        if (authType == 'login') {
          debugPrint('in login');
          userCredential = await auth.signInWithEmailAndPassword(
            email: formData['email'],
            password: formData['password'],
          );
        }
        if (authType == 'signup') {
          userCredential = await auth.createUserWithEmailAndPassword(
            email: formData['email'],
            password: formData['password'],
          );
          // debugPrint(value.toString());
          debugPrint('User created successfully');
          await FirebaseHelper.sendVerificationMailToUser();
          await ProfileHelper.saveUserDataInFirestore(
            imgPath: formData['image'],
            name: formData['name'],
          );
        }
      }
    } on FirebaseAuthException catch (err) {
      // var errMsg = 'Something went wrong';

      ModalHelpers.createAlertDialog(
          context, err.code.split('-').join(' ').toUpperCase(), err.message!);
    } catch (error) {
      debugPrint(error.toString());
      ModalHelpers.createAlertDialog(
          context, 'Auth Error Happened', error.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      body: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: AuthForm(
            _getFormData,
            _isLoading,
            type: widget.authType,
          ),
        ),
      ),
    );
  }
}
