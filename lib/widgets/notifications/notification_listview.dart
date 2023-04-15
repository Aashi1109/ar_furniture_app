import 'package:flutter/material.dart';

import 'notification_item.dart';
import '../../providers/notification_provider.dart';

class NotificationListview extends StatelessWidget {
  const NotificationListview(this.notifications, {super.key});
  final List<NotificationItemModel> notifications;

  @override
  Widget build(BuildContext context) {
    // final mediaQuerySize = MediaQuery.of(context).size.height;
    return Expanded(
      // height:
      //     MediaQuery.of(context).size.height * (.105 * notifications.length),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemBuilder: (ctx, index) {
          final id = notifications[index].id;
          // final title = notifications[index].title;
          // final text = notifications[index].text;
          // final icon = notifications[index].icon;
          // final isRead = notifications[index].isRead;
          // final createdAt = notifications[index].createdAt;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: NotificationItem(
              id: id,
              // title: title,
              // text: text,
              // icon: icon,
              // isRead: isRead,
              // createdAt: createdAt,
            ),
          );
        },
        itemCount: notifications.length,
      ),
    );
  }
}
