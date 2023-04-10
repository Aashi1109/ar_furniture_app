import 'package:decal/helpers/material_helper.dart';
import 'package:decal/screens/auth_screen.dart';
import 'package:flutter/material.dart';

class ForgetScreenItem extends StatelessWidget {
  const ForgetScreenItem({
    super.key,
    required this.title,
    required this.text,
    required this.icon,
    this.actionWidget,
    this.showLoginButton = true,
  });
  final String title;
  final String text;
  final IconData icon;
  // final String buttonText;
  final Widget? actionWidget;
  final bool showLoginButton;

  @override
  Widget build(BuildContext context) {
    final themeColorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                5,
              ),
              border: Border.all(
                color: themeColorScheme.tertiary,
                width: 2,
              ),
            ),
            width: 40,
            height: 40,
            child: Icon(
              icon,
              color: themeColorScheme.primary,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: themeColorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(text),
          const SizedBox(
            height: 30,
          ),
          if (actionWidget != null) actionWidget!,
          if (showLoginButton) ...[
            const SizedBox(
              height: 30,
            ),
            Align(
              alignment: const Alignment(0, 0),
              child: MaterialHelper.buildWholeClickableText(
                text: '<- Back to Login',
                onPressHandler: () {
                  Navigator.of(context)
                      .pushReplacementNamed(AuthScreen.namedRoute);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
