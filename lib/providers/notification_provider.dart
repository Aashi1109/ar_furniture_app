import 'package:decal/helpers/firebase/notification_helper.dart';
import 'package:decal/helpers/general_helper.dart';
import 'package:flutter/material.dart';

class NotificationItemModel {
  final String text;
  final String id;
  final String title;
  final IconData icon;
  bool isRead;

  NotificationItemModel({
    required this.text,
    required this.id,
    required this.title,
    required this.icon,
    this.isRead = false,
  });
}

class NotificationProviderModel extends ChangeNotifier {
  List<NotificationItemModel> _notifications = [];
  bool _showNotiWindow = false;

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

  void addNotification(NotificationItemModel data) {
    if (!_notifications.any((element) => element.text == data.text)) {
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
          NotficationHelper.deleteNotiFromFireStore('', deleteAll: deleteAll);
        } catch (error) {
          _notifications.insert(existingNotiIndex, existingNoti);
          notifyListeners();
          debugPrint('error deleting noti from firestore ${error.toString()}');
        }
      }
    }
  }

  void markAsRead(String notiId, {bool toAll = false}) {
    for (var element in _notifications) {
      if (toAll) {
        element.isRead = true;
      } else {
        if (element.id == notiId) {
          element.isRead = true;
        }
      }
    }
    notifyListeners();
  }

  Future<void> getAndSetNotiData() async {
    final loadedNoti = await NotficationHelper.getNotificationsFromFirestore();
    List tempNoti = [];
    for (var data in loadedNoti.docs) {
      tempNoti.add(
        NotificationItemModel(
          text: data.data()['text'],
          id: data.id,
          title: data.data()['title'],
          icon: GeneralHelper.getIconDataFromIconString(
            data.data()['iconData'],
          ),
        ),
      );
    }

    _notifications = List<NotificationItemModel>.from(tempNoti);
    notifyListeners();
  }
}
