import 'package:flutter/material.dart';

class AuthBottom extends StatelessWidget {
  const AuthBottom(this.isLoginForm, this.setAuthHandler, {super.key});
  final bool isLoginForm;
  final Function setAuthHandler;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Flexible(
              child: Divider(
                thickness: 1,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              'OR ${isLoginForm ? 'login' : 'signup'} with',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            const Flexible(
              child: Divider(
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // InkWell(
            //   onTap: () => setAuthHandler('google'),
            //   child: CircleAvatar(
            //     backgroundImage: const AssetImage('assets/icons/google.png'),
            //     backgroundColor: themeColorScheme.onPrimary,
            //   ),
            // ),
            OutlinedButton.icon(
              onPressed: () => setAuthHandler('google'),
              icon: Image.asset(
                'assets/icons/google.png',
                width: 28,
              ),
              label: Text(
                '${isLoginForm ? "Login" : "Signup"} with Google',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            // const SizedBox(
            //   width: 20,
            // ),
            // InkWell(
            //   onTap: () => setAuthHandler('facebook'),
            //   child: const CircleAvatar(
            //     backgroundImage: AssetImage('assets/icons/facebook.png'),
            //   ),
            // ),
          ],
        )
      ],
    );
  }
}
