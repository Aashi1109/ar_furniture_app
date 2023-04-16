import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../helpers/material_helper.dart';
import '../../widgets/user/user_settings.dart';

class UserSettingsScreen extends StatelessWidget {
  const UserSettingsScreen({super.key});
  static const namedRoute = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(
          kDefaultPadding,
        ),
        child: Column(
          children: [
            MaterialHelper.buildCustomAppbar(
              context,
              'Settings',
            ),
            const UserSettings(),
          ],
        ),
      ),
    );
  }
}
