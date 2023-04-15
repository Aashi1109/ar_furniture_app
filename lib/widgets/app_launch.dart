import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:decal/helpers/shared_preferences_helper.dart';
import 'package:decal/screens/onboard_screen.dart';
import 'package:decal/widgets/auth/auth_stream_handler.dart';

class AppLaunch extends StatelessWidget {
  const AppLaunch({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferencesHelper.preferences,
      builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
        debugPrint('in shared pref section');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          debugPrint('error in sharedpref ${snapshot.error}');
        }
        final isOnboardingShown =
            snapshot.data?.getBool('viewedOnboard') ?? false;
        debugPrint('onboarding value $isOnboardingShown');
        return isOnboardingShown
            ? const AuthStreamHandler()
            : const OnboardScreen();
      },
    );
  }
}
