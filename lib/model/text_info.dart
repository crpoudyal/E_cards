import 'package:flutter/material.dart';

class TextInfo {
  String text;
  double left;
  double top;
  Color color;
  FontWeight fontWeight;
  TextDecoration underline;
  TextDecoration linethrough;
  FontStyle fontStyle;
  double fontSize;
  TextAlign textAlign;

  TextInfo({
    required this.text,
    required this.left,
    required this.top,
    required this.color,
    required this.fontWeight,
    required this.underline,
    required this.linethrough,
    required this.fontStyle,
    required this.fontSize,
    required this.textAlign,
  });
}
