import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decal/helpers/firebase_helper.dart';
import 'package:decal/helpers/general_helper.dart';
import 'package:decal/providers/notification_provider.dart';

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
      return FirebaseHelper.clearCollection(notiCollection);
    } else {
      return notiCollection.doc(notiId).delete();
    }
  }
}
