import 'package:flutter/material.dart';

class SimpleTextWidget extends StatelessWidget {
  const SimpleTextWidget({
    super.key,
    required this.text,
    required this.fontWeight,
    required this.color,
    required this.fontSize,
  });

  final String text;
  final FontWeight fontWeight;
  final Color? color;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}
