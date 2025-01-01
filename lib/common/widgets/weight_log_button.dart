// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:daily_weight_logs_mobile/common/constants/colors.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_text.dart';

class WeightLogButton extends StatelessWidget {
  final Key? key;
  final bool isEnabled;
  final VoidCallback? onPressed;
  final String text;
  final bool? isLoading;
  final Color buttonTextColor;
  final FontWeight buttonTextFontWeight;

  const WeightLogButton({
    this.key,
    this.isEnabled = true,
    this.onPressed,
    required this.text,
    this.isLoading = false,
    this.buttonTextColor = Colors.white,
    this.buttonTextFontWeight = FontWeight.w600,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(MediaQuery.sizeOf(context).width, 53),
        backgroundColor: isEnabled ? secondaryColor : const Color(0xFFD8D8D8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: isEnabled ? onPressed : null,
      child: WeightLogText(
        text: text,
        color: buttonTextColor,
        fontSize: 16,
        fontWeight: buttonTextFontWeight,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
