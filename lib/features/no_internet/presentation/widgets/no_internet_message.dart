import 'package:daily_weight_logs_mobile/common/constants/colors.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_button.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_text.dart';
import 'package:flutter/material.dart';

class NoInternetMessage extends StatefulWidget {
  final VoidCallback onRetry;

  const NoInternetMessage({super.key, required this.onRetry});

  @override
  State<NoInternetMessage> createState() => _NoInternetMessageState();
}

class _NoInternetMessageState extends State<NoInternetMessage> {
  bool isRetryDisabled = false;

  void handleRetry() {
    if (!isRetryDisabled) {
      setState(() => isRetryDisabled = true);
      widget.onRetry();

      // Re-enable retry after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (context.mounted) setState(() => isRetryDisabled = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.wifi_off, size: 100, color: grayTextColor),
        const SizedBox(height: 16),
        WeightLogText(
          text: 'No Internet Connection',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: grayTextColor,
        ),
        const SizedBox(height: 8),
        WeightLogText(
          text: 'Please check your internet settings and try again.',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: grayTextColor,
        ),
        const SizedBox(height: 32),
        WeightLogButton(
          text: isRetryDisabled ? "Retrying..." : "Try Again",
          onPressed: isRetryDisabled ? null : handleRetry,
          buttonBackgroundColor: isRetryDisabled ? grayTextColor : primaryColor,
          buttonTextColor: secondaryColor,
        ),
      ],
    );
  }
}
