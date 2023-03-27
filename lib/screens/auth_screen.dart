import 'package:decal/helpers/firebase_helper.dart';
import 'package:decal/helpers/modal_helper.dart';
import 'package:decal/widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'dart:io';

class AuthScreen extends StatefulWidget {
  static const namedRoute = '/auth-screen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Map<String, Object>? _formData;
  bool _isLoading = false;

  void _getFormData(
    formData,
    String authType,
  ) async {
    debugPrint(formData.toString());

    final _auth = FirebaseAuth.instance;
    UserCredential userCredential;
    setState(() {
      _isLoading = true;
    });
    try {
      if (authType == 'login') {
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
        final imagePath = formData['image'];
        final imagePathSplit = imagePath.toString().split('/');
        final imageUploadTask = FirebaseHelper.uploadImage(
          File(imagePath.toString()),
          imagePathSplit[imagePathSplit.length - 1],
        );
        final imageUrl = await (await imageUploadTask).ref.getDownloadURL();

        await FirebaseHelper.saveExtraUserDataInFirestore({
          'imageUrl': imageUrl,
          'name': formData['name'],
        });
      }
    } on FirebaseAuthException catch (err) {
      var errMsg = 'Something went wrong';

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
          ),
        ),
      ),
    );
  }
}
