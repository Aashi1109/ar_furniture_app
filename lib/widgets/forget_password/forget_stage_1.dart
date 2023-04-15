import '../../helpers/material_helper.dart';
import 'package:flutter/material.dart';

class ForgetStage1 extends StatelessWidget {
  ForgetStage1(this.setData, this.buttonText, {super.key});
  final Function setData;
  final String buttonText;
  final _formGlobalKey = GlobalKey<FormState>();

  _submitData(BuildContext context) {
    final isFormValid = _formGlobalKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (isFormValid != null && isFormValid) {
      _formGlobalKey.currentState?.save();
      setData(
        {
          'email': enteredMail.trim(),
        },
      );
    }
  }

  String enteredMail = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formGlobalKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Email'),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'your@email.com',
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
            ),
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Email address can\'t be empty.';
              }
              if (value != null && !value.contains('@')) {
                return 'Invalid email address';
              }
              return null;
            },
            onSaved: (value) {
              enteredMail = value!;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          MaterialHelper.buildLargeElevatedButton(
            context,
            buttonText,
            pressHandler: () => _submitData(context),
            border: const RoundedRectangleBorder(),
          ),
        ],
      ),
    );
  }
}
