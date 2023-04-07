import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/material_helper.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';
import '../../screens/user_account_screen.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColorScheme = Theme.of(context).colorScheme;

    // final notiProvider = Provider.of<NotificationProviderModel>(context);

    return FutureBuilder(builder: (_, snapShot) {
      if (snapShot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (snapShot.hasError) {
        return Text(snapShot.error.toString());
      }
      return ListTile(
        horizontalTitleGap: 10,
        contentPadding: EdgeInsets.zero,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(UserAccountScreen.namedRoute);
          },
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child:
                  Consumer<AuthProviderModel>(builder: (context, provider, _) {
                return Image.network(
                  provider.userImageUrl,
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                        'assets/images/defaults/default_user.png');
                  },
                );
              }),
            ),
          ),
        ),
        title: Text(
          'Welcome',
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        subtitle: Consumer<AuthProviderModel>(
          builder: (context, provider, ch) {
            return Text(
              provider.userName,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: themeColorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            );
          },
        ),
        trailing: Consumer<NotificationProviderModel>(
          builder: (context, provider, ch) {
            return Stack(
              clipBehavior: Clip.none,
              children: [
                MaterialHelper.buildRoundedElevatedButton(
                  context,
                  Icons.notifications_none_rounded,
                  themeColorScheme,
                  () {
                    provider.toggleNotiWindow();
                  },
                  iconSize: 20,
                ),
                if (provider.unreadNotifications.isNotEmpty) ch!,
              ],
            );
          },
          child: Positioned(
            top: 6,
            right: 5,
            child: CircleAvatar(
              backgroundColor: themeColorScheme.error,
              radius: 4,
            ),
          ),
        ),
      );
    });
  }
}
