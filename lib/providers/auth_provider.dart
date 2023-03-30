import 'package:decal/helpers/firebase_helper.dart';
import 'package:flutter/material.dart';
import '../models/auth.dart';

class AuthProviderModel extends ChangeNotifier {
  AuthModel _auth = AuthModel(
    imageUrl: '',
    name: '',
    userCreationDate: DateTime.now(),
  );

  Future<void> getAndSetAuthData() async {
    try {
      final authResp = await FirebaseHelper.getUserProfileDataFromFirestore();
      // for (var element in authResp.docs) {
      // debugPrint(element.data().toString());
      // debugPrint(authResp.data().toString());
      _auth = AuthModel(
        imageUrl: authResp.data()?['imageUrl'],
        name: authResp.data()?['name'],
        userCreationDate:
            authResp.data()?['userCreationDate']?.toDate() ?? DateTime.now(),
      );
      // }
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

  DateTime get userCreationDate {
    return _auth.userCreationDate;
  }
}
