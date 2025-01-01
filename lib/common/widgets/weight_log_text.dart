import 'package:daily_weight_logs_mobile/common/constants/colors.dart';
import 'package:flutter/material.dart';

class WeightLogText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final double height;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final VoidCallback? onPressed;

  const WeightLogText({
    required this.text,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w600,
    this.color = secondaryColor,
    this.textAlign = TextAlign.left,
    this.overflow = TextOverflow.clip,
    super.key,
    this.height = 1.2,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
        ),
        textAlign: textAlign,
        overflow: overflow,
      ),
    );
  }
}
