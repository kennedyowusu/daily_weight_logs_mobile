import 'package:daily_weight_logs_mobile/common/constants/colors.dart';
import 'package:flutter/material.dart';

class WeightLogLoadingDialog extends StatelessWidget {
  final String message;

  const WeightLogLoadingDialog({super.key, this.message = 'Loading...'});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: const Key('loading_dialog'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      content: Row(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
          ),
          const SizedBox(width: 16),
          Text(message),
        ],
      ),
    );
  }
}
