import 'package:decal/helpers/general_helper.dart';
import 'package:decal/helpers/modal_helper.dart';
import 'package:decal/screens/admin/admin_screen.dart';
import 'package:decal/widgets/admin/admin_code_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../helpers/material_helper.dart';
import '../../providers/auth_provider.dart';
import '../../providers/orders_provider.dart';

import 'order_screen.dart';
import 'favourite_screen.dart';
import 'screenshots_screen.dart';
import 'user_account_edit_screen.dart';
import 'user_settings_screen.dart';

class UserAccountScreen extends StatelessWidget {
  const UserAccountScreen({super.key});
  static const namedRoute = '/user-account';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final themeColorScheme = Theme.of(context).colorScheme;
    final authProvider = Provider.of<AuthProviderModel>(
      context,
      listen: false,
    );
    // final cartProvider = Provider.of<CartProviderModel>(context, listen: false);
    final orderProvider =
        Provider.of<OrderProviderModel>(context, listen: false);
    return Scaffold(
      body: FutureBuilder(
          future: orderProvider.getAndSetOrdersData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              children: [
                Stack(
                  children: [
                    Container(
                      color: themeColorScheme.primary,
                      height: mediaQuery.size.height * .4,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: mediaQuery.size.height * .1,
                          ),
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                radius: 55,
                                backgroundColor: themeColorScheme.onPrimary,
                                child: CircleAvatar(
                                  backgroundColor: themeColorScheme.primary,
                                  radius: 52,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      authProvider.userImageUrl,
                                    ),
                                    radius: 46,
                                  ),
                                ),
                              ),
                              if (authProvider.isAdmin)
                                const Positioned(
                                  top: -6,
                                  right: -8,
                                  child: Icon(
                                    Icons.admin_panel_settings_rounded,
                                    color: Colors.green,
                                    size: 36,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            authProvider.userName,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                  color: themeColorScheme.onPrimary,
                                ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Joined on ${DateFormat.yMMMd().format(authProvider.userCreationDate)}',
                                  style: TextStyle(
                                    color: themeColorScheme.onPrimary,
                                  ),
                                ),
                                VerticalDivider(
                                  color: themeColorScheme.tertiary,
                                  thickness: 2,
                                ),
                                Text(
                                  '${orderProvider.orders.length.toString()} Orders',
                                  style: TextStyle(
                                    color: themeColorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: mediaQuery.padding.top,
                      child: PopupMenuButton(
                        icon: Icon(
                          Icons.more_vert_rounded,
                          color: themeColorScheme.onPrimary,
                        ),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: TextButton.icon(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                    UserAccountEditScreen.namedRoute,
                                  );
                                },
                                icon: Icon(
                                  Icons.edit_rounded,
                                  color: themeColorScheme.primary,
                                ),
                                label: const Text(
                                  'Edit Account Info',
                                ),
                              ),
                            ),
                            if (authProvider.isAdmin)
                              PopupMenuItem(
                                child: TextButton.icon(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AdminCodeForm(),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.admin_panel_settings_rounded,
                                    color: themeColorScheme.primary,
                                  ),
                                  label: const Text(
                                    'Admin Page',
                                  ),
                                ),
                              ),
                          ];
                        },
                      ),
                    ),
                    Positioned(
                      left: 10,
                      top: mediaQuery.padding.top,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          left: 5,
                        ),
                        child: MaterialHelper.buildRoundedElevatedButton(
                          context,
                          null,
                          () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  // height: mediaQuery.size.height * .6,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.email_rounded,
                            color: themeColorScheme.primary,
                          ),
                          title: const Text(
                            'Email',
                          ),
                          subtitle: Text(
                              FirebaseAuth.instance.currentUser?.email ?? ''),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(OrderScreen.namedRoute);
                          },
                          leading: Icon(
                            Icons.credit_card_rounded,
                            color: themeColorScheme.primary,
                          ),
                          title: const Text('Order History'),
                          trailing: const Icon(
                            Icons.keyboard_arrow_right_rounded,
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(FavouriteScreen.namedRoute);
                          },
                          leading: Icon(
                            Icons.favorite_outline_rounded,
                            color: themeColorScheme.primary,
                          ),
                          title: const Text('Favourites'),
                          trailing: const Icon(
                            Icons.keyboard_arrow_right_rounded,
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              ScreenshotsScreen.namedRoute,
                            );
                          },
                          leading: Icon(
                            Icons.image_rounded,
                            color: themeColorScheme.primary,
                          ),
                          title: const Text(
                            'Screenshots',
                            style: TextStyle(
                                // color: themeColorScheme.error,
                                ),
                          ),
                          trailing: const Icon(
                            Icons.keyboard_arrow_right_rounded,
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              UserSettingsScreen.namedRoute,
                            );
                          },
                          leading: Icon(
                            Icons.settings_suggest_rounded,
                            color: themeColorScheme.primary,
                          ),
                          title: const Text(
                            'Settings',
                            style: TextStyle(
                                // color: themeColorScheme.error,
                                ),
                          ),
                          trailing: const Icon(
                            Icons.keyboard_arrow_right_rounded,
                          ),
                        ),
                        const Spacer(),
                        ListTile(
                          onTap: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.of(context).pop();
                          },
                          leading: Icon(
                            Icons.exit_to_app_rounded,
                            color: themeColorScheme.error,
                          ),
                          title: Text(
                            'Logout',
                            style: TextStyle(
                              color: themeColorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
