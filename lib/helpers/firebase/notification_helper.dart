import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_helper.dart';
import '../general_helper.dart';
import '../../providers/notification_provider.dart';

class NotficationHelper {
  static const notificationCollectionPath = 'notifications';

  static CollectionReference<Map<String, dynamic>> getNotificationCollection() {
    return FirebaseHelper.getUserDoc().collection(notificationCollectionPath);
  }

  static Future<void> addNotificationToFireStore(
      NotificationItemModel notiData) async {
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

  static Future<QuerySnapshot<Map<String, dynamic>>>
      getNotificationsFromFirestore() {
    return getNotificationCollection()
        .orderBy(
          'createdAt',
          descending: true,
        )
        .get();
  }

  static Future<void> deleteNotiFromFireStore(String notiId,
      {bool deleteAll = false}) {
    final notiCollection = getNotificationCollection();
    if (deleteAll) {
      return FirebaseHelper.clearFirestoreCollection(notiCollection);
    } else {
      return notiCollection.doc(notiId).delete();
    }
  }

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
