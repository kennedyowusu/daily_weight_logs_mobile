import 'package:daily_weight_logs_mobile/common/constants/colors.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_text.dart';
import 'package:flutter/material.dart';

class ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final bool isEditable;
  final bool isPassword;

  const ProfileField({
    super.key,
    required this.label,
    required this.value,
    this.isEditable = false,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WeightLogText(text: label, color: primaryColor, fontSize: 14),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: WeightLogText(
                  text: value,
                  color: Colors.white,
                  fontSize: 16,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isEditable)
                Icon(
                  isPassword ? Icons.visibility : Icons.edit,
                  color: primaryColor,
                ),
            ],
          ),
          const Divider(
            color: Colors.white,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
