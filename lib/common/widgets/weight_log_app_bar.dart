import 'package:flutter/material.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_text.dart';

class WeightLogAppBar extends StatelessWidget {
  const WeightLogAppBar({
    super.key,
    required this.titleText,
    this.backgroundColor,
    this.textColor,
    this.elevation,
    this.leading,
    this.automaticallyImplyLeading = true,
  });

  final String titleText;
  final Color? backgroundColor;
  final Color? textColor;
  final double? elevation;
  final Widget? leading;
  final bool automaticallyImplyLeading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: elevation ?? 0.3,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      title: WeightLogText(
        text: titleText,
        color: textColor ?? Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    );
  }
}
