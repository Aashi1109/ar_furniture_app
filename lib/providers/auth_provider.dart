import '../constants.dart';
import '../helpers/general_helper.dart';
import 'notification_provider.dart';

import '../helpers/firebase/profile_helper.dart';
import 'package:flutter/material.dart';
import '../models/auth.dart';

class AuthProviderModel extends ChangeNotifier {
  NotificationProviderModel? _notificationProvider;

  set notificationProvider(NotificationProviderModel notificationProvider) {
    _notificationProvider = notificationProvider;
  }

  AuthModel _auth = AuthModel(
    imageUrl: '',
    name: '',
    userCreationDate: DateTime.now(),
  );
  bool _isInitData = true;
  bool _isUserDataUpdated = false;

  Future<void> getAndSetAuthData({bool isUpdate = false}) async {
    return GeneralHelper.getAndSetWrapper(
      _isInitData,
      () async {
        final authResp = await ProfileHelper.getUserProfileDataFromFirestore();
        _auth = AuthModel(
          imageUrl: authResp.data()?['imageUrl'],
          name: authResp.data()?['name'],
          userCreationDate:
              authResp.data()?['userCreationDate']?.toDate() ?? DateTime.now(),
        );

        notifyListeners();
        _isUserDataUpdated = isUpdate;
        if (_isUserDataUpdated) {
          _notificationProvider?.addNotification(
            NotificationItemModel(
                text: authNotification['t1']!['text']!,
                id: DateTime.now().toString(),
                title: authNotification['t1']!['title']!,
                icon: Icons.check_circle,
                action: {
                  'action': 'auth',
                  'params': '',
                }),
          );
          _isInitData = false;
          _isUserDataUpdated = false;
        }
      },
    );
    // if (_isInitData) {
    //   try {
    //     final authResp = await ProfileHelper.getUserProfileDataFromFirestore();
    //     _auth = AuthModel(
    //       imageUrl: authResp.data()?['imageUrl'],
    //       name: authResp.data()?['name'],
    //       userCreationDate:
    //           authResp.data()?['userCreationDate']?.toDate() ?? DateTime.now(),
    //     );

    //     notifyListeners();
    //     _isUserDataUpdated = isUpdate;
    //     if (_isUserDataUpdated) {
    //       _notificationProvider?.addNotification(
    //         NotificationItemModel(
    //           text: authNotification['t1']!['text']!,
    //           id: DateTime.now().toString(),
    //           title: authNotification['t1']!['title']!,
    //           icon: Icons.check_circle,
    //             action: {
    //               'action': 'auth',
    //               'params': '',
    //             }
    //         ),
    //       );
    //       _isUserDataUpdated = false;
    //     }
    //   } catch (error) {
    //     debugPrint(error.toString());
    //   }
    // } else {
    // _isInitData = false;
    //   return;
    // }
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
