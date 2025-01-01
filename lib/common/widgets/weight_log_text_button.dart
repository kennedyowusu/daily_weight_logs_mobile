import 'package:daily_weight_logs_mobile/common/constants/colors.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_text.dart';
import 'package:flutter/material.dart';

class WeightLogTextButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback? onPressed;
  final String text;
  final Color textColor;
  final FontWeight textFontWeight;
  final double fontSize;

  const WeightLogTextButton({
    super.key,
    this.isEnabled = true,
    this.onPressed,
    required this.text,
    this.textColor = primaryColor,
    this.textFontWeight = FontWeight.w600,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isEnabled ? onPressed : null,
      style: TextButton.styleFrom(
        foregroundColor:
            isEnabled ? textColor : const Color(0xFFBDBDBD), // Disabled color
        textStyle: TextStyle(
          fontWeight: textFontWeight,
          fontSize: fontSize,
        ),
      ),
      child: WeightLogText(
        text: text,
        color: isEnabled ? textColor : const Color(0xFFBDBDBD),
        fontSize: fontSize,
        fontWeight: textFontWeight,
        textAlign: TextAlign.center,
      ),
    );
  }
}
