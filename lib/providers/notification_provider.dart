import 'package:cloud_firestore/cloud_firestore.dart';
import '../helpers/firebase/notification_helper.dart';
import '../helpers/general_helper.dart';
import 'package:flutter/material.dart';

class NotificationItemModel {
  final String text;
  final String id;
  final String title;
  final IconData icon;
  DateTime createdAt;
  bool isRead;
  Map<String, dynamic>? action;

  NotificationItemModel({
    required this.text,
    required this.id,
    required this.title,
    required this.icon,
    this.isRead = false,
    DateTime? createdAt,
    this.action,
  }) : createdAt = createdAt ?? DateTime.now();
}

class NotificationProviderModel extends ChangeNotifier {
  List<NotificationItemModel> _notifications = [];
  bool _showNotiWindow = false;
  bool _isInitData = true;

  bool get notiWindowStatus {
    return _showNotiWindow;
  }

  void toggleNotiWindow() {
    _showNotiWindow = !_showNotiWindow;
    notifyListeners();
  }

  List<NotificationItemModel> get notifications {
    return [..._notifications];
  }

  List<NotificationItemModel> get unreadNotifications {
    return _notifications.where((element) => !element.isRead).toList();
  }

  List<NotificationItemModel> get readNotifications {
    return _notifications.where((element) => element.isRead).toList();
  }

  NotificationItemModel getNotificationById(String notiId) {
    return _notifications.firstWhere((element) => element.id == notiId);
  }

  void addNotification(NotificationItemModel data, {bool isNew = true}) {
    bool toAddNoti = _notifications.any((element) => element.text == data.text);
    if (isNew) {
      toAddNoti = false;
    }
    if (!toAddNoti) {
      _notifications.insert(
        0,
        data,
      );
      try {
        NotficationHelper.addNotificationToFireStore(data);
      } catch (error) {
        debugPrint('error adding noti to firestore ${error.toString()}');
      }
      notifyListeners();
    }
  }

  Future<void> removeNotification(String notiId,
      {bool deleteAll = false}) async {
    // debugPrint('in remove noti');
    if (deleteAll) {
      final prevNoti = [..._notifications];
      try {
        await NotficationHelper.deleteNotiFromFireStore(
          '',
          deleteAll: deleteAll,
        );
        _notifications.clear();
        notifyListeners();
      } catch (error) {
        _notifications = [...prevNoti];
        notifyListeners();
        debugPrint(
            'error deleting all noti from firestore ${error.toString()}');
      }
    } else {
      final existingNotiIndex =
          _notifications.indexWhere((element) => element.id == notiId);
      if (existingNotiIndex >= 0) {
        final existingNoti = _notifications[existingNotiIndex];
        _notifications.removeAt(existingNotiIndex);
        notifyListeners();
        try {
          NotficationHelper.deleteNotiFromFireStore(notiId,
              deleteAll: deleteAll);
        } catch (error) {
          _notifications.insert(existingNotiIndex, existingNoti);
          notifyListeners();
          debugPrint('error deleting noti from firestore ${error.toString()}');
        }
      }
    }
  }

  void markAsRead(String notiId, {bool toAll = false}) {
    // debugPrint('in mark as read noti');
    try {
      for (var element in _notifications) {
        if (toAll) {
          element.isRead = true;
        } else {
          if (element.id == notiId) {
            element.isRead = true;
          }
        }
      }

      NotficationHelper.markNotiAsReadInFirestore(
        notiId,
        updateAll: toAll,
      );
      notifyListeners();
    } catch (error) {
      debugPrint('error in marking read noti ${error.toString()}');
    }
  }

  Future<void> getAndSetNotiData() async {
    return GeneralHelper.getAndSetWrapper(_isInitData, () async {
      final loadedNoti =
          await NotficationHelper.getNotificationsFromFirestore();
      List tempNoti = [];
      for (var data in loadedNoti.docs) {
        tempNoti.add(
          NotificationItemModel(
            text: data.data()['text'],
            id: data.id,
            title: data.data()['title'],
            createdAt: (data.data()['createdAt'] as Timestamp).toDate(),
            icon: GeneralHelper.getIconDataFromIconString(
              data.data()['iconData'],
            ),
            isRead: data.data()['isRead'],
            action: data.data()['action'],
          ),
        );
      }

      _notifications = List<NotificationItemModel>.from(tempNoti);
      notifyListeners();
    });
    // if (_isInitData) {
    //   final loadedNoti =
    //       await NotficationHelper.getNotificationsFromFirestore();
    //   List tempNoti = [];
    //   for (var data in loadedNoti.docs) {
    //     tempNoti.add(
    //       NotificationItemModel(
    //         text: data.data()['text'],
    //         id: data.id,
    //         title: data.data()['title'],
    //         createdAt: (data.data()['createdAt'] as Timestamp).toDate(),
    //         icon: GeneralHelper.getIconDataFromIconString(
    //           data.data()['iconData'],
    //         ),
    //         isRead: data.data()['isRead'],
    //         action: data.data()['action'],
    //       ),
    //     );
    //   }

    //   _notifications = List<NotificationItemModel>.from(tempNoti);
    //   notifyListeners();
    // } else {
    //   _isInitData = false;
    //   return;
    // }
  }
}
