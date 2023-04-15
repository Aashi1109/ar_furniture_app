import 'package:decal/screens/auth/auth_screen.dart';
import 'package:decal/screens/auth/email_verification_screen.dart';
import 'package:decal/widgets/main_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthStreamHandler extends StatelessWidget {
  const AuthStreamHandler({super.key});
  static const namedRoute = '/auth-stream-handler';

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments;

    String authType = 'login';
    if (routeArgs != null) {
      authType = routeArgs as String;
    }
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // debugPrint(
        //     'firebase auth stream connection state ${snapshot.connectionState}');

        if (snapshot.hasData) {
          // debugPrint('in stream data section');
          User user = snapshot.data!;
          if (user.emailVerified) {
            // debugPrint('in email verified section');
            return const MainApp();
          } else {
            return FutureBuilder(
                future: user.reload(),
                builder: (context, snapshot) {
                  // debugPrint('in email verification section');
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return EmailVerificationScreen();
                });
            // user.reload();
          }
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return AuthScreen(
          authType: authType,
        );
      },
    );
  }
}
