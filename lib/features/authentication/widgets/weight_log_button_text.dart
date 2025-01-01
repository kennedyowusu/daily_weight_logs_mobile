import 'package:daily_weight_logs_mobile/common/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_text.dart';

class WeightLogButtonText extends StatelessWidget {
  final String mainText;
  final String actionText;
  final String route;
  final TextStyle? mainTextStyle;
  final TextStyle? actionTextStyle;

  const WeightLogButtonText({
    super.key,
    required this.mainText,
    required this.actionText,
    required this.route,
    this.mainTextStyle,
    this.actionTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WeightLogText(
          text: mainText,
          fontSize: mainTextStyle?.fontSize ?? 14,
          fontWeight: mainTextStyle?.fontWeight ?? FontWeight.normal,
          color: mainTextStyle?.color ?? Colors.black,
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, route);
          },
          child: WeightLogText(
            text: actionText,
            fontSize: actionTextStyle?.fontSize ?? 14,
            fontWeight: actionTextStyle?.fontWeight ?? FontWeight.bold,
            color: actionTextStyle?.color ?? secondaryColor,
          ),
        ),
      ],
    );
  }
}
