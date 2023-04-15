import 'package:flutter/material.dart';

enum PasswordStrengthEnum {
  Weak,
  Medium,
  Strong,
}

class PasswordStrength extends StatefulWidget {
  const PasswordStrength(this.controller, {super.key});
  final TextEditingController controller;

  @override
  State<PasswordStrength> createState() => _PasswordStrengthState();
}

class _PasswordStrengthState extends State<PasswordStrength> {
  PasswordStrengthEnum getPasswordStrength(String password) {
    // Check password strength and return enum value
    if (password.length < 9) {
      return PasswordStrengthEnum.Weak;
    } else if (password.length > 12 &&
        (password.contains(RegExp(r'[0-9]')) &&
            password.contains(RegExp(r'[a-z]')) &&
            password.contains(RegExp(r'[A-Z]')) &&
            password.contains(
              RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
            ))) {
      return PasswordStrengthEnum.Strong;
    } else {
      return PasswordStrengthEnum.Medium;
    }
  }

  int getPasswordStrengthInInt(PasswordStrengthEnum val) {
    switch (val) {
      case PasswordStrengthEnum.Medium:
        return PasswordStrengthEnum.Medium.index;
      case PasswordStrengthEnum.Strong:
        return PasswordStrengthEnum.Strong.index;
      case PasswordStrengthEnum.Weak:
        return PasswordStrengthEnum.Weak.index;
    }
  }

  Widget buildStrengthBars({
    required ColorScheme colorScheme,
    required int curStrength,
    int barCount = 3,
  }) {
    dynamic barColor;
    String textValue = 'Weak';
    if (curStrength == 1) {
      barColor = colorScheme.error;
    } else if (curStrength == 2) {
      barColor = colorScheme.primary;
      textValue = 'Medium';
    } else if (curStrength > 2) {
      barColor = Colors.greenAccent;
      textValue = 'Strong';
    }
    if (widget.controller.text.isEmpty && widget.controller.text.length < 8) {
      barColor = Colors.black12;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.controller.text.length > 7) ...[
          Text(
            textValue,
            style: TextStyle(
              color: barColor,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
        Row(
          children: List.generate(barCount, (index) => index)
              .map(
                (e) => Expanded(
                  child: Container(
                    height: 8,
                    margin: EdgeInsets.only(
                      right: (e + 1 == barCount) ? 0 : 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      color: e < curStrength ? barColor : Colors.black12,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  int _currentStrength = 0;

  @override
  Widget build(BuildContext context) {
    final themeColorScheme = Theme.of(context).colorScheme;
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Password',
          ),
          // const SizedBox(
          //   height: -5,
          // ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'New password',
            ),
            controller: widget.controller,
            obscureText: true,
            onChanged: (value) {
              final strengthEnum = getPasswordStrength(value);

              setState(() {
                _currentStrength = getPasswordStrengthInInt(strengthEnum) + 1;
              });
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Password cannot be empty';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          buildStrengthBars(
            colorScheme: themeColorScheme,
            curStrength: _currentStrength,
          ),
        ],
      ),
    );
  }
}
