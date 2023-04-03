import 'package:cloud_firestore/cloud_firestore.dart';
import '../helpers/firebase/profile_helper.dart';
import '../helpers/firebase_helper.dart';
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

    final _auth = FirebaseAuth.instanceFor(
      app: Firebase.app(),
    );
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
        final imageUploadTask = ProfileHelper.uploadImage(
          File(imagePath.toString()),
          imagePathSplit[imagePathSplit.length - 1],
        );
        final imageUrl = await (await imageUploadTask).ref.getDownloadURL();

        await ProfileHelper.saveExtraUserDataInFirestore({
          'imageUrl': imageUrl,
          'name': formData['name'],
          'createdAt': Timestamp.now(),
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
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    var type;
    if (routeArgs != null) {
      debugPrint(routeArgs.toString());
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
            type: type ?? '',
          ),
        ),
      ),
    );
  }
}
