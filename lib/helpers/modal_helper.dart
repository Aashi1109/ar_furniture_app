import 'package:flutter/material.dart';

/// It contains methods to create dialogs and snackbars to increase interactivity
/// with user and provide them with valid error and app states.
class ModalHelpers {
  /// Create bottom modal sheet which takes content to be displayed in the sheet.
  static createBottomModal(BuildContext context, dynamic content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (ctx) {
        return content;
      },
    );
  }

  /// Creates alert dialog informing user about their actions. if `closeContent` is
  /// set `true` then you have to provide list of actions which you want to use on
  /// `AlertDialog` otherwise it will automatically provide a `Okay` action
  /// button to close the dialog.
  static Future<T?> createAlertDialog<T>(
    BuildContext context,
    String title,
    String content, {
    Widget? cusContent,
    bool closeContent = true,
    List<Widget> actions = const [],
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          if (closeContent)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Okay'),
            ),
          if (!closeContent) ...actions,
        ],
        content: cusContent ?? Text(content),
        title: Text(title),
      ),
    );
  }

  /// Creates bottom snackbar informing user about a event. Each snackbar is
  /// displayed for 2 seconds can be changed by setting [duration] variable.
  /// Previous Snackbars are automatically hidden before showing new one.
  static createInfoSnackbar(BuildContext context, String message,
      {int duration = 2}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(
          seconds: duration,
        ),
      ),
    );
  }

  static Future<bool?> confirmUserChoiceDialog(
    BuildContext context,
    String title,
    String contentText,
  ) async {
    return ModalHelpers.createAlertDialog<bool>(
      context,
      title,
      contentText,
      closeContent: false,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(
            'No',
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(
            'Yes',
          ),
        ),
      ],
    );
  }
}
