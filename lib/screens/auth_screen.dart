import 'package:cloud_firestore/cloud_firestore.dart';
import '../helpers/authentication_helper.dart';
import '../helpers/firebase/profile_helper.dart';

import '../helpers/modal_helper.dart';
import '../widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'dart:io';

class AuthScreen extends StatefulWidget {
  static const namedRoute = '/auth-screen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Map<String, Object>? _formData;
  bool _isLoading = false;

  void _getFormData(
    formData,
    String authType,
  ) async {
    debugPrint(formData.toString());

    // final _auth = FirebaseAuth.instanceFor(
    //   app: await Firebase.initializeApp(
    //     name: 'decal',
    //     options: Firebase.app().options,
    //   ),
    // );
    FirebaseAuth _auth = FirebaseAuth.instance;
    // _auth = FirebaseAuth.instance;

    UserCredential userCredential;
    setState(() {
      _isLoading = true;
    });
    try {
      if (formData['handler'] != null) {
        if (formData['handler'] == 'google') {
          // final userCred = ;
          userCredential = await _auth.signInWithCredential(
            await AuthenticationHelper.authWithGoogle(),
          );
          if (userCredential.additionalUserInfo?.isNewUser == true) {
            // if (userCredential.additionalUserInfo?.isNewUser == true) {
            await ProfileHelper.saveUserDataInFirestore(
              userCredential.user?.displayName ?? '',
              '',
              imageUrl: userCredential.user?.photoURL,
            );
          }
          // else {
          //   userCredential = await _auth.signInWithCredential(
          //     await AuthenticationHelper.authWithFacebook(),
          //   );
          // }

          // }
        }
      } else {
        if (authType == 'login') {
          debugPrint('in login');
          userCredential = await _auth.signInWithEmailAndPassword(
            email: formData['email'],
            password: formData['password'],
          );
        }
        if (authType == 'signup') {
          userCredential = await _auth.createUserWithEmailAndPassword(
            email: formData['email'],
            password: formData['password'],
          );
          // debugPrint(value.toString());
          debugPrint('User created successfully');
          await ProfileHelper.saveUserDataInFirestore(
            formData['image'],
            formData['name'],
          );
        }
      }
      // Navigator.of(context).pus
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
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    String type = '';
    if (routeArgs != null) {
      // debugPrint(
      //   routeArgs.toString(),
      // );
      type = routeArgs as String;
    }

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
            type: type,
          ),
        ),
      ),
    );
  }
}
