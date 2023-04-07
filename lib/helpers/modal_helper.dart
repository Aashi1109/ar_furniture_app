import 'package:flutter/material.dart';

class ModalHelpers {
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

  static Future<T?> createAlertDialog<T>(
    BuildContext context,
    String title,
    String content, {
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
        content: Text(content),
        title: Text(title),
      ),
    );
  }

  static createInfoSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(
          seconds: 2,
        ),
      ),
    );
  }
}
