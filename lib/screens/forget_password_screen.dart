import 'package:decal/constants.dart';
import 'package:decal/helpers/material_helper.dart';
import 'package:decal/widgets/forget_password/forget_password_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../helpers/modal_helper.dart';
import 'package:flutter/material.dart';
import '../widgets/current_page_shower.dart';
import '../widgets/forget_password/forget_stage_1.dart';
import '../widgets/forget_password/forget_stage_2.dart';
import '../widgets/forget_password/forget_stage_3.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});
  static const namedRoute = '/forget-screen';

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  List<Map<String, Object>> _forgetEnteredData = [];
  bool isDataEmptyInMap(Map<String, String> dataToCheck) {
    for (var key in dataToCheck.keys) {
      if (dataToCheck[key]!.isEmpty) {
        return true;
      }
    }
    return false;
  }

  String? _enteredEmail;

  _handleIncomingForgetData(Map<String, String> data) {
    final dataCheck = isDataEmptyInMap(data);
    if (_currentIndex == 3) {
      return;
    }
    if (!dataCheck) {
      _forgetEnteredData.add(
        {
          'stage${_currentIndex + 1}': data,
        },
      );
      if (data.containsKey('email')) {
        _enteredEmail = data['email'];
      }

      setState(() {
        ++_currentIndex;
      });
    }
  }

  _printForgetData() {
    debugPrint(_forgetEnteredData.toString());
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Map<String, Object>> _forgetScreenMsg = [
      {
        'title': 'Forget Password?',
        'text':
            'Enter the email associated with your account and we\'ll send an email with instructions to reset your password.',
        'widget': ForgetStage1(
          _handleIncomingForgetData,
          'Reset Password',
        ),
        'icon': Icons.fingerprint_rounded,
      },
      {
        'title': 'Password reset',
        'text': 'We had send a email with code to ${_enteredEmail ?? ''}',
        'widget': ForgetStage2(
          _handleIncomingForgetData,
          'Continue',
        ),
        'icon': Icons.mark_email_read_rounded,
      },
      {
        'title': 'Set new password',
        'text': 'Must be atleast 8 characters.',
        'widget': ForgetStage3(
          _handleIncomingForgetData,
          'Reset Password',
        ),
        'icon': Icons.keyboard_rounded,
      },
      {
        'title': 'All done',
        'text':
            'Your password has been reset. Now you can continue with your new credentials.',
        'buttonText': 'Login Now',
        'widget': MaterialHelper.buildLargeElevatedButton(
          context,
          'Login Now',
          _printForgetData,
          border: const RoundedRectangleBorder(),
        ),
        'icon': Icons.safety_check,
        'hideLoginArrow': true,
      },
    ];
    return WillPopScope(
      onWillPop: () async {
        bool? exit = await ModalHelpers.createAlertDialog<bool>(
          context,
          'Are you sure',
          'Do you not want to recover your password?',
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

        if (exit != null) {
          if (exit == true) {
            return true;
          }
        }
        return false;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(
            kDefaultPadding,
          ),
          child: Column(
            children: [
              MaterialHelper.buildCustomAppbar(
                context,
                '',
              ),
              const Spacer(
                flex: 4,
              ),
              ForgetScreenItem(
                title: _forgetScreenMsg[_currentIndex]['title'] as String,
                text: _forgetScreenMsg[_currentIndex]['text'] as String,
                actionWidget:
                    _forgetScreenMsg[_currentIndex]['widget'] as Widget,
                icon: _forgetScreenMsg[_currentIndex]['icon'] as IconData,
                showLoginButton: !((_forgetScreenMsg[_currentIndex]
                        ['hideLoginArrow'] ??
                    false) as bool),
              ),
              const Spacer(
                flex: 6,
              ),
              BottomPageShower(
                currentIndex: _currentIndex + 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
