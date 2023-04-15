import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../widgets/verification/verification_code_timer.dart';

class EmailVerificationScreen extends StatelessWidget {
  EmailVerificationScreen({super.key});
  static const namedRoute = '/email-verification';
  final currentUserEmail = FirebaseAuth.instance.currentUser?.email;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final themeColorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(
          kDefaultPadding,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // const SizedBox(
              //   height: 50,
              // ),
              Image.asset(
                'assets/images/email_verification.png',
                height: 250,
                width: double.infinity,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Verify your Email Address',
                style: textTheme.displayMedium?.copyWith(
                  color: themeColorScheme.primary,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'You have entered $currentUserEmail as email address for your account.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'A email is send from Decal please verify your email address from there.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 50,
              ),
              // MaterialHelper.buildLargeElevatedButton(
              //     context, 'Open Mail App', () {}),
              const VerificationCodeTimer(),
              // EmailVerifierWithCode()
            ],
          ),
        ),
      ),
    );
  }
}
