import 'package:flutter/material.dart';

import '../constants.dart';
import '../helpers/firebase/profile_helper.dart';
import '../helpers/general_helper.dart';
import '../models/auth.dart';
import 'notification_provider.dart';

/// It provides data for Authentication and expose methods to access or change
/// this data.
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
  // bool _isUserDataUpdated = false;

  /// Get and set data for auth for the first time amd when `isUpdate` is true.
  /// isUpdate is used to generate notification message for data updated and also
  /// helpful when we have to reinitialize data.
  Future<void> getAndSetAuthData({bool isUpdate = false}) async {
    return GeneralHelper.getAndSetWrapper(
      _isInitData || isUpdate,
      () async {
        final authResp = await ProfileHelper.getUserProfileDataFromFirestore();
        _auth = AuthModel(
          imageUrl: authResp.data()?['imageUrl'],
          name: authResp.data()?['name'],
          isAdmin: authResp.data()?['isAdmin'] ?? false,
          userCreationDate:
              authResp.data()?['userCreationDate']?.toDate() ?? DateTime.now(),
        );

        notifyListeners();
        // _isUserDataUpdated = isUpdate;
        if (isUpdate) {
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

  bool get isAdmin {
    return _auth.isAdmin;
  }
}
