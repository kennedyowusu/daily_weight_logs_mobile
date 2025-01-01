import 'package:daily_weight_logs_mobile/common/constants/colors.dart';
import 'package:daily_weight_logs_mobile/common/constants/images.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_button.dart';
import 'package:daily_weight_logs_mobile/common/widgets/weight_log_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const WeightLogText(
                text: 'You seem lost!',
                fontSize: 20,
                textAlign: TextAlign.center,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 24),
              SvgPicture.asset(
                pageNotFound,
                height: 300,
                width: 300,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 24),
              const WeightLogText(
                text: 'The page you are looking for is unavailable.',
                fontSize: 16,
                textAlign: TextAlign.center,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              WeightLogButton(
                text: 'Go back',
                buttonTextColor: secondaryColor,
                buttonTextFontWeight: FontWeight.bold,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
