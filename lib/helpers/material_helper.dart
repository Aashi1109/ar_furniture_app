import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Contains helpers related to flutter widgets and material.
class MaterialHelper {
  /// Creates a Material swatch from `Color`
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

  /// Build custom appbar having elevated button which by default takes back to
  /// previous screen but this can be modified by setting `onPress` parameter.
  /// One action button can be used by using `action` parameter.
  static Widget buildCustomAppbar(BuildContext context, String appBarTitle,
      {VoidCallback? onPress, Widget? action}) {
    final themeColorScheme = Theme.of(context).colorScheme;
    onPress ??= () {
      Navigator.of(context).pop();
    };
    // debugPrint(onPress.toString());
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 60,
      width: double.infinity,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MaterialHelper.buildRoundedElevatedButton(
            context,
            null,
            onPress,
          ),
          const Spacer(),
          Text(
            appBarTitle,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: themeColorScheme.primary,
                ),
          ),
          const Spacer(),
          SizedBox(
            width: 32,
            child: action,
          ),
        ],
      ),
    );
  }

  /// This builds clickable some clickable texts in a paragraph of text. Click
  /// action can be handled by assigning `clickHandler` parameter.
  static buildClickableText(BuildContext context, String text,
      String clickableText, VoidCallback clickHandler) {
    TextStyle defaultStyle =
        const TextStyle(color: Colors.grey, fontSize: 16.0);
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
        ],
      ),
    );
  }

  /// Creates a rounded elevated button having icon not texts. The icons and button
  /// can be totally modified by leveraging different parameters.
  ///
  ///  By default,
  /// icon used is `Icons.Icons.keyboard_arrow_left_rounded`, color is primary and
  /// button size is 32. All this can be modified.
  static Widget buildRoundedElevatedButton(
    BuildContext context,
    IconData? iconData,
    // ColorScheme themeColorScheme,
    VoidCallback? onPressedHandler, {
    OutlinedBorder? borderStyle,
    double? iconSize,
    double? buttonSize,
    Color? buttonColor,
  }) {
    final themeColorScheme = Theme.of(context).colorScheme;
    return ElevatedButton(
      onPressed: onPressedHandler,
      style: ElevatedButton.styleFrom(
        shape: borderStyle ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.square(buttonSize ?? 32),
        maximumSize: Size.square(buttonSize ?? 32),
        padding: EdgeInsets.zero,

        // side: ,
        backgroundColor: buttonColor ?? themeColorScheme.onPrimary,
      ),
      child: Icon(
        iconData ?? Icons.keyboard_arrow_left_rounded,
        size: iconSize ?? 30,
        color: themeColorScheme.primary,
      ),
    );
  }

  /// Builds large elevated button having text not icon covering whole width and
  /// height is 35.
  static buildLargeElevatedButton(
    BuildContext context,
    String title, {
    VoidCallback? pressHandler,
    OutlinedBorder? border,
    double? buttonSize,
    double? textSize,
    double? padding,
  }) {
    final themeColorScheme = Theme.of(context).colorScheme;
    return ElevatedButton(
      onPressed: pressHandler,
      style: ElevatedButton.styleFrom(
        shape: border ?? const StadiumBorder(),
        minimumSize: Size.fromHeight(buttonSize ?? 35),
        padding: EdgeInsets.all(
          padding ?? 15,
        ),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: textSize,
              color: themeColorScheme.onPrimary,
            ),
      ),
    );
  }

  /// Creates clickable text
  static Widget buildWholeClickableText({
    required String text,
    required VoidCallback onPressHandler,
    TextStyle? textStyle,
  }) {
    return InkWell(
      onTap: onPressHandler,
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }
}
