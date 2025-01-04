import 'package:daily_weight_logs_mobile/common/constants/colors.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_text.dart';
import 'package:daily_weight_logs_mobile/features/no_internet/application/no_internet_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/no_internet_message.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  void handleRetry(BuildContext context, WidgetRef ref) async {
    final isConnected =
        await ref.read(noInternetRepositoryProvider).isConnected();

    if (isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: WeightLogText(
            text: "Connection restored! Redirecting...",
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: secondaryColor,
          ),
          backgroundColor: primaryColor,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: WeightLogText(
            text: "No internet connection. Please try again.",
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Consumer(
            builder: (context, ref, _) {
              return NoInternetMessage(
                onRetry: () => handleRetry(context, ref),
              );
            },
          ),
        ),
      ),
    );
  }
}
