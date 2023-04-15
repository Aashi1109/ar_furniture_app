import 'package:flutter/material.dart';

import '../../helpers/modal_helper.dart';
import '../../constants.dart';
import '../../widgets/user/user_header.dart';

import 'users/admin_user_screen.dart';
import 'product/admin_product_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});
  static const namedRoute = '/admin-page';

  @override
  Widget build(BuildContext context) {
    final themeColorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: kDefaultPadding + MediaQuery.of(context).viewPadding.top,
          bottom: kDefaultPadding,
          right: kDefaultPadding,
          left: kDefaultPadding,
        ),
        child: WillPopScope(
          onWillPop: () async {
            bool? exit = await ModalHelpers.confirmUserChoiceDialog(
              context,
              'Admin Page',
              'Do you want to exit, Admin?',
            );

            if (exit == true) {
              return true;
            } else {
              return false;
            }
          },
          child: Column(
            children: [
              const UserHeader(
                isAdminPage: true,
              ),
              ListTile(
                splashColor: themeColorScheme.tertiary,
                contentPadding: EdgeInsets.zero,
                leading: const Text(
                  'Products',
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AdminProductScreen.namedRoute,
                  );
                },
                trailing: Icon(
                  Icons.keyboard_arrow_right_rounded,
                  color: themeColorScheme.primary,
                ),
              ),
              ListTile(
                splashColor: themeColorScheme.tertiary,
                contentPadding: EdgeInsets.zero,
                leading: const Text(
                  'Users',
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AdminUsersScreen.namedRoute,
                  );
                },
                trailing: Icon(
                  Icons.keyboard_arrow_right_rounded,
                  color: themeColorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
