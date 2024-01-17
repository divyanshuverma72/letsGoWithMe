import 'package:flutter/material.dart';

class FilledCardTextButton extends StatelessWidget {
  const FilledCardTextButton(
      {super.key,
      required this.title,
      required this.backgroundColor,
      required this.buttonHeight,
      required this.buttonWidth,
      required this.fontSize});

  final String title;
  final Color? backgroundColor;
  final double? buttonHeight;
  final double? buttonWidth;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: backgroundColor,
      child: SizedBox(
        height: buttonHeight,
        width: buttonWidth,
        child: Center(
            child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: fontSize),
        )),
      ),
    );
  }
}
