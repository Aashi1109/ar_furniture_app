import 'package:decal/providers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    required this.id,
    required this.title,
    required this.text,
    required this.icon,
    required this.isRead,
    super.key,
  });
  final String id;
  final IconData icon;
  final String title;
  final String text;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final notiProvider =
        Provider.of<NotificationProviderModel>(context, listen: false);
    return ClipRRect(
      child: Dismissible(
        key: ValueKey('$isRead$id'),
        direction: DismissDirection.horizontal,
        onDismissed: (direction) {
          switch (direction) {
            case DismissDirection.endToStart:
              notiProvider.markAsRead(id);
              break;
            case DismissDirection.startToEnd:
              notiProvider.removeNotification(id);
              break;
            default:
          }
        },
        background: Container(
          color: Colors.green,
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.check_rounded,
            color: colorScheme.onPrimary,
          ),
        ),
        secondaryBackground: Container(
          color: colorScheme.error,
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.delete_rounded,
            color: colorScheme.onPrimary,
          ),
        ),
        child: Container(
            decoration: BoxDecoration(
              color: colorScheme.tertiary,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 1,
                color: colorScheme.primary,
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: colorScheme.primary,
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title),
                      Text(
                        text,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
