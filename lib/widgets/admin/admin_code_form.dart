import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../helpers/general_helper.dart';
import '../../helpers/material_helper.dart';
import '../../helpers/modal_helper.dart';
import '../../screens/admin/admin_screen.dart';

class AdminCodeForm extends StatelessWidget {
  AdminCodeForm({super.key});

  final _textController =
      TextEditingController(); // Create a text controller to get the text field value

  void _onSubmit(BuildContext context) async {
    final res = await GeneralHelper.checkAdminRight(
      _textController.text.trim(),
    );
    if (res) {
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(
        AdminScreen.namedRoute,
      );
    } else {
      Navigator.of(context).pop();
      ModalHelpers.createInfoSnackbar(
        context,
        "Wrong access code",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      buttonPadding: const EdgeInsets.only(
        bottom: kDefaultPadding,
        right: kDefaultPadding,
        left: kDefaultPadding,
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: kDefaultPadding + 10,
      ),
      title: const Text('Access code'),
      content: TextField(
        textAlign: TextAlign.center,
        controller:
            _textController, // Use the text controller for the text field
      ),
      actions: [
        MaterialHelper.buildLargeElevatedButton(
          context,
          'Check code',
          pressHandler: () => _onSubmit(
            context,
          ),
          buttonSize: 20,
          textSize: 18,
        )
      ],
    );
  }
}
