import 'package:decal/providers/notification_provider.dart';
import 'package:decal/widgets/notifications/notification_item.dart';
import 'package:flutter/material.dart';

class NotificationListview extends StatelessWidget {
  const NotificationListview(this.notifications, {super.key});
  final List<NotificationItemModel> notifications;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemBuilder: (ctx, index) {
          return Container(
            margin: const EdgeInsets.only(
              bottom: 10,
            ),
            child: NotificationItem(
              id: notifications[index].id,
              title: notifications[index].title,
              text: notifications[index].text,
              icon: notifications[index].icon,
              isRead: notifications[index].isRead,
            ),
          );
        },
        itemCount: notifications.length,
      ),
    );
  }
}
