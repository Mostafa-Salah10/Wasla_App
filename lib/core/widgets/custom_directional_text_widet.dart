import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const CustomTextWidget({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  bool _containsArabic(String value) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(value);
  }

  String _fixMixedText(String value) {
    return '\u202B$value\u202C';
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = _containsArabic(text);

    return Directionality(
      textDirection:
          isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Text(
        _fixMixedText(text),
        textAlign: textAlign ?? TextAlign.start,
        maxLines: maxLines,
        overflow: overflow,
        style: style ??
            const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
      ),
    );
  }
}