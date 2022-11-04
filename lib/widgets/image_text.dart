import 'package:Ecards/model/text_info.dart';
import 'package:flutter/material.dart';

class ImageText extends StatelessWidget {
  final TextInfo textInfo;

  const ImageText({Key? key, required this.textInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      textInfo.text,
      textAlign: textInfo.textAlign,
      style: TextStyle(
        fontSize: textInfo.fontSize,
        fontWeight: textInfo.fontWeight,
        fontStyle: textInfo.fontStyle,
        color: textInfo.color,
        decoration: textInfo.underline,
      ),
    );
  }
}
