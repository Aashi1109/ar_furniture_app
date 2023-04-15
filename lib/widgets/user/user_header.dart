import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/material_helper.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';
import '../../screens/user/user_account_screen.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({
    super.key,
    this.isAdminPage = false,
  });

  final bool isAdminPage;

  @override
  Widget build(BuildContext context) {
    final themeColorScheme = Theme.of(context).colorScheme;

    // final authProvider = Provider.of<AuthProviderModel>(context);

    return FutureBuilder(
        future: Provider.of<AuthProviderModel>(
          context,
          listen: false,
        ).getAndSetAuthData(),
        builder: (_, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapShot.hasError) {
            return Text(snapShot.error.toString());
          }
          return Consumer<AuthProviderModel>(builder: (
            context,
            authProvider,
            ch,
          ) {
            return ListTile(
              horizontalTitleGap: 10,
              contentPadding: EdgeInsets.zero,
              leading: InkWell(
                onTap: isAdminPage
                    ? null
                    : () {
                        Navigator.of(context).pushNamed(
                          UserAccountScreen.namedRoute,
                        );
                      },
                child: Container(
                  decoration: authProvider.isAdmin
                      ? BoxDecoration(
                          border: Border.all(
                            color: Colors.green,
                          ),
                          borderRadius: BorderRadius.circular(
                            8,
                          ),
                        )
                      : null,
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 3,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: FadeInImage(
                          image: NetworkImage(
                            authProvider.userImageUrl,
                          ),
                          placeholder: const AssetImage(
                            'assets/images/defaults/default_user.png',
                          ),
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                          imageErrorBuilder: (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return Image.asset(
                              'assets/images/defaults/default_user.png',
                            );
                          },
                        )),
                  ),
                ),
              ),
              title: Text(
                isAdminPage ? 'Admin' : 'Welcome',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              subtitle: Text(
                authProvider.userName,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: themeColorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              trailing: isAdminPage
                  ? null
                  : Consumer<NotificationProviderModel>(
                      builder: (context, provider, ch) {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            MaterialHelper.buildRoundedElevatedButton(
                              context,
                              Icons.notifications_none_rounded,
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
        });
  }
}
