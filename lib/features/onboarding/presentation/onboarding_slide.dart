import 'package:daily_weight_logs_mobile/common/widgets/weight_log_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OnboardingSlide extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const OnboardingSlide({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(image, height: 300, width: 300, fit: BoxFit.cover),
        const SizedBox(height: 24),
        WeightLogText(
          text: title,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          textAlign: TextAlign.center,
          color: Colors.white,
        ),
        const SizedBox(height: 16),
        WeightLogText(
          text: description,
          fontSize: 16,
          textAlign: TextAlign.center,
          color: Colors.white,
        ),
      ],
    );
  }
}
