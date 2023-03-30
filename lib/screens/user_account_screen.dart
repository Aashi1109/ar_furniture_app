import 'package:decal/helpers/material_helper.dart';
import 'package:decal/providers/auth_provider.dart';

import 'package:decal/providers/orders_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'order_screen.dart';
import 'favourite_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class UserAccountScreen extends StatelessWidget {
  const UserAccountScreen({super.key});
  static const namedRoute = '/user-account';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final themeColorScheme = Theme.of(context).colorScheme;
    final authProvider = Provider.of<AuthProviderModel>(context, listen: false);
    // final cartProvider = Provider.of<CartProviderModel>(context, listen: false);
    final orderProvider =
        Provider.of<OrderProviderModel>(context, listen: false);
    return Scaffold(
      body: Column(
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
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      authProvider.userName,
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
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
                child: IconButton(
                  icon: Icon(
                    Icons.edit_square,
                    color: themeColorScheme.onPrimary,
                  ),
                  onPressed: () {},
                ),
              ),
              Positioned(
                left: 10,
                top: mediaQuery.padding.top,
                child: MaterialHelper.buildRoundedElevatedButton(
                    context, null, themeColorScheme, () {
                  Navigator.of(context).pop();
                }),
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
                    title: Text(
                      'Email',
                    ),
                    subtitle:
                        Text(FirebaseAuth.instance.currentUser?.email ?? ''),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.credit_card_rounded,
                      color: themeColorScheme.primary,
                    ),
                    title: const Text('Orders'),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: themeColorScheme.primary,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(OrderScreen.namedRoute);
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.favorite_outline_rounded,
                      color: themeColorScheme.primary,
                    ),
                    title: const Text('Favourites'),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: themeColorScheme.primary,
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(FavouriteScreen.namedRoute);
                      },
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
      ),
    );
  }
}