import 'package:flutter/material.dart';

class ResponsiveText extends StatefulWidget {
  const ResponsiveText(
    this.text, {
    this.style,
    this.textAlign,
    super.key,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  State<ResponsiveText> createState() => _ResponsiveTextState();
}

class _ResponsiveTextState extends State<ResponsiveText> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final style = widget.style ?? const TextStyle();
      final scaleFactor = constraints.maxWidth / 1200;
      final fontSize = (style.fontSize ?? 16) * scaleFactor;
      return Text(
        widget.text,
        style: style.copyWith(fontSize: fontSize),
        textAlign: widget.textAlign,
      );
    });
  }
}