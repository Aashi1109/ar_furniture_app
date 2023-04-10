import 'package:decal/helpers/material_helper.dart';
import 'package:flutter/material.dart';

import '../password_strength.dart';

class ForgetStage3 extends StatelessWidget {
  ForgetStage3(this.setData, this.buttonText, {super.key});
  final Function setData;
  final String buttonText;
  String confirmPassword = '';
  final _formKey = GlobalKey<FormState>();

  _submitHandler(BuildContext context) {
    final formIsValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (formIsValid) {
      setData(
        {
          'password': passwordController.text.trim(),
        },
      );
    }
  }

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          PasswordStrength(
            passwordController,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text('Confirm Password'),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Confirm Password',
            ),
            obscureText: true,
            validator: (value) {
              if (value!.trim() != passwordController.text.trim()) {
                return 'Passwords don\'t match';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 30,
          ),
          MaterialHelper.buildLargeElevatedButton(
            context,
            buttonText,
            () => _submitHandler(
              context,
            ),
            border: const RoundedRectangleBorder(),
          ),
        ],
      ),
    );
  }
}
