import 'package:decal/helpers/material_helper.dart';
import 'package:flutter/material.dart';
import 'code_field.dart';

class EmailCodeForm extends StatefulWidget {
  EmailCodeForm(this.setCode, this.requiredCode, this.buttonText, {super.key});
  final String buttonText;
  final Function setCode;
  final String requiredCode;

  @override
  State<EmailCodeForm> createState() => _EmailCodeFormState();
}

class _EmailCodeFormState extends State<EmailCodeForm> {
  final code1FocusNode = FocusNode();
  final code2FocusNode = FocusNode();

  final code3FocusNode = FocusNode();

  final code4FocusNode = FocusNode();

  // final code5FocusNode = FocusNode();
  // final requiredCode = '1234';
  bool _isWrong = false;
  List<String> _codeEntered = [];
  final _formGlobalKey = GlobalKey<FormState>();

  _getData(value) {
    _codeEntered.add(value);
  }

  _submitHandler() {
    _formGlobalKey.currentState?.save();
    final enteredCode = _codeEntered.join('');
    if (enteredCode != widget.requiredCode) {
      debugPrint(enteredCode);
      debugPrint('in wrong true sett');
      _codeEntered.clear();
      setState(() {
        _isWrong = true;
      });
    } else {
      setState(() {
        _isWrong = false;
      });
      widget.setCode(
        {
          'enteredOTP': enteredCode.toString(),
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final themeColorScheme = Theme.of(context).colorScheme;

    return Form(
      key: _formGlobalKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CodeField(
                isWrong: _isWrong,
                ownFocusNode: code1FocusNode,
                nextFocusNode: code2FocusNode,
                setData: _getData,
              ),
              const SizedBox(
                width: 10,
              ),
              CodeField(
                isWrong: _isWrong,
                ownFocusNode: code2FocusNode,
                nextFocusNode: code3FocusNode,
                previousFocusNode: code1FocusNode,
                setData: _getData,
              ),
              const SizedBox(
                width: 10,
              ),
              CodeField(
                isWrong: _isWrong,
                ownFocusNode: code3FocusNode,
                nextFocusNode: code4FocusNode,
                previousFocusNode: code2FocusNode,
                setData: _getData,
              ),
              const SizedBox(
                width: 10,
              ),
              CodeField(
                isWrong: _isWrong,
                ownFocusNode: code4FocusNode,
                previousFocusNode: code3FocusNode,
                setData: _getData,
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          MaterialHelper.buildLargeElevatedButton(
            context,
            widget.buttonText,
            _submitHandler,
            border: const RoundedRectangleBorder(),
          ),
        ],
      ),
    );
  }
}
