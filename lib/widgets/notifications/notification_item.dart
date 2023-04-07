import '../../helpers/general_helper.dart';
import '../../providers/notification_provider.dart';
import '../../screens/auth_screen.dart';
import '../../screens/cart_screen.dart';
import '../../screens/order_screen.dart';
import '../../screens/product_detail_screen.dart';
import '../../screens/review_rating_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    required this.id,
    // required this.title,
    // required this.text,
    // required this.icon,
    // required this.isRead,
    // required this.createdAt,
    super.key,
  });
  final String id;
  // final IconData icon;
  // final String title;
  // final String text;
  // final bool isRead;
  // final DateTime createdAt;

  final smallTextStyle = const TextStyle(
    fontSize: 14,
  );
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final notiProvider =
        Provider.of<NotificationProviderModel>(context, listen: false);
    final foundNoti = notiProvider.getNotificationById(id);
    return ClipRRect(
      child: Dismissible(
        key: ValueKey(id),
        direction: (foundNoti.isRead || notiProvider.notifications.length == 1)
            ? DismissDirection.endToStart
            : DismissDirection.horizontal,
        dismissThresholds: const {
          DismissDirection.startToEnd: .4,
        },
        onDismissed: (direction) {
          switch (direction) {
            case DismissDirection.endToStart:
              debugPrint('');
              notiProvider.removeNotification(id);
              return;
            case DismissDirection.startToEnd:
              notiProvider.markAsRead(id);
              return;
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
        child: InkWell(
          onTap: () {
            notiProvider.toggleNotiWindow();
            if (foundNoti.action?['action'] != null) {
              switch (foundNoti.action?['action']) {
                case 'cart':
                  Navigator.of(context).pushNamed(CartScreen.namedRoute);
                  break;
                case 'auth':
                  Navigator.of(context).pushNamed(AuthScreen.namedRoute);
                  break;
                case 'product':
                  Navigator.of(context).pushNamed(
                    ProductDetailScreen.namedRoute,
                    arguments: foundNoti.action?['params'],
                  );
                  break;
                case 'order':
                  Navigator.of(context).pushNamed(
                    OrderScreen.namedRoute,
                  );
                  break;
                case 'review':
                  Navigator.of(context).pushNamed(
                    ReviewRatingScreen.namedRoute,
                    arguments: foundNoti.action?['params'],
                  );
                  break;
              }
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.tertiary,
              borderRadius: BorderRadius.circular(10),
              border: foundNoti.isRead
                  ? null
                  : Border.all(
                      width: 1,
                      color: colorScheme.error,
                    ),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  foundNoti.icon,
                  color: colorScheme.primary,
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(foundNoti.title),
                          FittedBox(
                            child: Text(
                              GeneralHelper.getTimeAgoString(
                                foundNoti.createdAt,
                              ),
                              style: smallTextStyle,
                            ),
                          )
                        ],
                      ),
                      Text(
                        foundNoti.text,
                        style: smallTextStyle,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
