import 'package:decal/helpers/firebase_helper.dart';
import 'package:flutter/material.dart';
import '../models/auth.dart';

class AuthProviderModel extends ChangeNotifier {
  AuthModel _auth = AuthModel(imageUrl: '', name: '');

  Future<void> getAndSetAuthData() async {
    try {
      final authResp = await FirebaseHelper.getUserProfileDataFromFirestore();
      for (var element in authResp.docs) {
        // debugPrint(element.data().toString());
        _auth = AuthModel(
            imageUrl: element.data()['imageUrl'], name: element.data()['name']);
      }
      notifyListeners();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  String get userName {
    return _auth.name;
  }

  String get userImageUrl {
    return _auth.imageUrl;
  }
}
