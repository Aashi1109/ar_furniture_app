import 'package:flutter/material.dart';

class CodeField extends StatefulWidget {
  const CodeField({
    super.key,
    required this.isWrong,
    this.ownFocusNode,
    this.nextFocusNode,
    required this.setData,
    this.fieldSize,
    this.fontSize,
    this.previousFocusNode,
    // this.otherCallback,
  });
  final bool isWrong;
  final FocusNode? ownFocusNode;
  final FocusNode? nextFocusNode;
  final FocusNode? previousFocusNode;
  final Function setData;
  // final VoidCallback? otherCallback;
  final double? fieldSize;
  final double? fontSize;

  @override
  State<CodeField> createState() => _CodeFieldState();
}

class _CodeFieldState extends State<CodeField> {
  // bool _isFilled = false;
  // bool _isFocused = false;
  @override
  Widget build(BuildContext context) {
    final themeColorScheme = Theme.of(context).colorScheme;

    return Container(
      height: widget.fieldSize ?? 45,
      width: widget.fieldSize ?? 45,
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.isWrong
              ? themeColorScheme.error
              : themeColorScheme.primary,
        ),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Center(
        child: TextFormField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
          ),
          initialValue: widget.isWrong ? '' : null,
          style: TextStyle(
            fontSize: widget.fontSize ?? 25,
          ),
          // cursorHeight: 25,
          textAlign: TextAlign.center,
          onChanged: (value) {
            // setState(() {
            //   // _isFilled = value.isNotEmpty;
            // });
            if (value.length == 1) {
              if (widget.nextFocusNode != null) {
                widget.nextFocusNode?.requestFocus();
              } else {
                widget.ownFocusNode?.unfocus();
              }
            }
            if (value.isEmpty) {
              if (widget.previousFocusNode != null) {
                widget.previousFocusNode?.requestFocus();
              }
            }
          },
          // onFieldSubmitted: (value) {
          //   // widget.setData(value);
          //   setState(() {
          //     _isFocused = false;
          //   });
          // },
          focusNode: widget.ownFocusNode,
          // onTap: () {
          //   setState(() {
          //     _isFocused = true;
          //   });
          // },
          onSaved: (value) {
            widget.setData(value?.trim());
          },
        ),
      ),
    );
  }
}
