import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_helper.dart';
import '../general_helper.dart';
import '../../providers/notification_provider.dart';

/// It holds all the methods to add, delete and update notifications data in
/// firestore. notifications data is store in userDoc having id as
/// `[notifications]`.
/// The Structure of how notifications's data is stored in firestore
/// `[users > userId > notifications > notificationsData]`.
/// No error handling is done is here it should be handled where you are using
/// it.

class NotficationHelper {
  static const notificationCollectionPath = 'notifications';

  /// Returns user notifications collection based on the data structure.
  static CollectionReference<Map<String, dynamic>> getNotificationCollection() {
    return FirebaseHelper.getUserDoc().collection(notificationCollectionPath);
  }

  /// Adds new notification to userDoc.
  /// `iconData` is string where `Icons.<icon_name>` is converted to string
  /// before storing it in firestore using
  /// `getIconDataString()` from `GeneralHelper` class.
  static Future<void> addNotificationToFireStore(
      NotificationItemModel notiData) async {
    ///
    final notificationCollection = getNotificationCollection();
    await notificationCollection.add({
      'isRead': notiData.isRead,
      'text': notiData.text,
      'title': notiData.title,
      'iconData': GeneralHelper.getIconDataString(notiData.icon),
      'createdAt': Timestamp.now(),
      'action': notiData.action,
    });
  }

  /// It returns all the notifications by ordering them in ascending order on
  /// field `createdAt` so that latest notifications are first.
  static Future<QuerySnapshot<Map<String, dynamic>>>
      getNotificationsFromFirestore() {
    return getNotificationCollection()
        .orderBy(
          'createdAt',
          descending: true,
        )
        .get();
  }

  /// This methods is used to delete some or every notifications from cloud.
  /// It `deleteAll` is set true it will delete every notifications from
  /// notifications collection by calling `clearFirestoreCollection()` from
  /// `FirebaseHelper` class.
  /// `notiId` won't be used in this case and viceversa. If it is provided
  /// only that particular notification is deleted.
  static Future<void> deleteNotiFromFireStore(String notiId,
      {bool deleteAll = false}) {
    final notiCollection = getNotificationCollection();
    if (deleteAll) {
      return FirebaseHelper.clearFirestoreCollection(notiCollection);
    } else {
      return notiCollection.doc(notiId).delete();
    }
  }

  /// Change the [isRead] property of a notification to `true` by using [notiId].
  /// if [updateAll] is true it will mark all notification's [isRead] as `true`.
  static Future<void> markNotiAsReadInFirestore(String notiId,
      {bool updateAll = false}) async {
    final notiCollection = getNotificationCollection();
    final notiDocs = await notiCollection.get();
    for (var noti in notiDocs.docs) {
      if (updateAll) {
        notiCollection.doc(noti.id).update({'isRead': true});
      } else {
        if (noti.id == notiId) {
          notiCollection.doc(noti.id).update({'isRead': true});
        }
      }
    }
  }
}
