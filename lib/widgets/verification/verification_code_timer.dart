import '../../constants.dart';
import '../../helpers/firebase_helper.dart';
import '../../helpers/general_helper.dart';
import '../../helpers/material_helper.dart';
import 'package:flutter/material.dart';

class VerificationCodeTimer extends StatefulWidget {
  const VerificationCodeTimer({super.key});

  @override
  _VerificationCodeTimerState createState() => _VerificationCodeTimerState();
}

class _VerificationCodeTimerState extends State<VerificationCodeTimer> {
  bool _showTimer = false;

  @override
  Widget build(BuildContext context) {
    final verificationCodeTimer = VerificationCodeTimerModel();
    return _showTimer
        ? StreamBuilder(
            stream: verificationCodeTimer.timerStream,
            builder: (context, AsyncSnapshot<int> snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                final secondsRemaining =
                    kVerificationCodeTimeoutSeconds - (snapshot.data ?? 0);
                if (secondsRemaining > 0) {
                  return Text('Resend code in $secondsRemaining s');
                }
              }
              return Builder(
                builder: (context) => MaterialHelper.buildClickableText(
                  context,
                  'Didn\'t receive mail ',
                  'RESEND IT',
                  () async {
                    verificationCodeTimer.start();
                    setState(() {});
                    await FirebaseHelper.sendVerificationMailToUser();
                  },
                ),
              );
            },
          )
        : MaterialHelper.buildClickableText(
            context,
            'Didn\'t receive code ',
            'RESEND IT',
            () async {
              setState(() {
                _showTimer = true;
              });
              await FirebaseHelper.sendVerificationMailToUser();
            },
          );
  }
}
