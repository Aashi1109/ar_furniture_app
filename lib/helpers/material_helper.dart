import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MaterialHelper {
  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};

    final int r = color.red, g = color.green, b = color.blue;

    for (var i = 0; i < 10; i++) {
      strengths.add(.1 * i);
    }

    for (var strength in strengths) {
      final double ds = .5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  static Widget buildCustomAppbar(BuildContext context, String appBarTitle) {
    final themeColorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 60,
      width: double.infinity,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MaterialHelper.buildRoundedElevatedButton(
              context, null, themeColorScheme, null),
          const Spacer(),
          Text(
            appBarTitle,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: themeColorScheme.primary,
                ),
          ),
          Spacer(),
          SizedBox(
            width: 32,
          ),
        ],
      ),
    );
  }

  static buildClickableText(BuildContext context, String text,
      String clickableText, VoidCallback clickHandler) {
    TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 16.0);
    TextStyle linkStyle = TextStyle(
      color: Theme.of(context).colorScheme.secondary,
    );
    return RichText(
      text: TextSpan(
        style: defaultStyle,
        children: <TextSpan>[
          TextSpan(text: text),
          TextSpan(
            text: clickableText,
            style: linkStyle,
            recognizer: TapGestureRecognizer()..onTap = clickHandler,
          )
          // TextSpan(text: ' and that you have read our '),
          // TextSpan(
          //     text: 'Privacy Policy',
          //     style: linkStyle,
          //     recognizer: TapGestureRecognizer()
          //       ..onTap = () {
          //         print('Privacy Policy"');
          //       }),
        ],
      ),
    );
  }

  static Widget buildRoundedElevatedButton(
    BuildContext context,
    IconData? iconData,
    ColorScheme themeColorScheme,
    VoidCallback? onPressedHandler,
  ) {
    // final themeColorScheme = Theme.of(context).colorScheme;
    return ElevatedButton(
      onPressed: onPressedHandler ??
          () {
            Navigator.of(context).pop();
          },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        // foregroundColor: Colors.amber,
        minimumSize: const Size.square(32),
        maximumSize: const Size.square(32),
        padding: EdgeInsets.zero,
        // side: ,
        backgroundColor: themeColorScheme.onPrimary,
      ),
      child: Icon(
        iconData ?? Icons.keyboard_arrow_left_rounded,
        size: 30,
        color: themeColorScheme.primary,
      ),
    );
  }
}
