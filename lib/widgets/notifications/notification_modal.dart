import '../../providers/notification_provider.dart';

import 'notification_item.dart';
import 'notification_listview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationModalWindow extends StatelessWidget {
  const NotificationModalWindow({
    super.key,
    required this.mediaQuery,
  });

  final MediaQueryData mediaQuery;
  final smallTextStyle = const TextStyle(
    fontSize: 14,
  );

  @override
  Widget build(BuildContext context) {
    final notiProvider =
        Provider.of<NotificationProviderModel>(context, listen: false);
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 10,
      child: Container(
        width: mediaQuery.size.width * .6,
        height: mediaQuery.size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: colorScheme.onPrimary,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 15,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notifications',
                    // style: ,
                  ),
                  InkWell(
                    onTap: notiProvider.toggleNotiWindow,
                    child: const Icon(
                      Icons.close_rounded,
                    ),
                  ),
                ],
              ),
              const Divider(),
              if (notiProvider.notifications.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All',
                      style: smallTextStyle,
                    ),
                    if (notiProvider.unreadNotifications.isNotEmpty)
                      InkWell(
                        onTap: () => notiProvider.markAsRead("", toAll: true),
                        child: Text(
                          'Mark all as read.',
                          style: smallTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                  ],
                ),
              const SizedBox(
                height: 10,
              ),
              Consumer<NotificationProviderModel>(
                  builder: (context, provider, child) {
                return provider.notifications.isEmpty
                    ? Expanded(
                        child: Center(
                          child: Text(
                            'No Notifications yet',
                            style: smallTextStyle,
                          ),
                        ),
                      )
                    : NotificationListview(
                        [
                          ...provider.unreadNotifications,
                          ...provider.readNotifications,
                        ],
                      );
              }),
              if (notiProvider.notifications.isNotEmpty) ...[
                const SizedBox(
                  height: 5,
                ),
                InkWell(
                  onTap: () {
                    notiProvider.toggleNotiWindow();
                    notiProvider.removeNotification('', deleteAll: true);
                  },
                  child: Text(
                    'Delete All Notifications',
                    style: smallTextStyle.copyWith(
                      color: colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
