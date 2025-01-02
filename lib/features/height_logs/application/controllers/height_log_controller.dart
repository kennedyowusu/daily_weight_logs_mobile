import 'package:daily_weight_logs_mobile/features/height_logs/data/repositories/height_log_repository.dart';

class HeightLogController {
  final HeightLogRepository repository;

  HeightLogController({required this.repository});

  Future<void> submitHeightLog(double height, String weightGoal) async {
    await repository.saveHeightLog(height, weightGoal);
  }

  double convertToMeters(String input, {bool isUsingFeet = false}) {
    if (isUsingFeet) {
      // Parse feet and inches input
      final parts = input.split('.');
      if (parts.isEmpty || parts.length > 2) {
        throw const FormatException('Invalid format for feet and inches.');
      }

      final feet = double.tryParse(parts[0]) ?? 0.0;
      final inches = parts.length == 2 ? double.tryParse(parts[1]) ?? 0.0 : 0.0;

      // Convert to meters: 1 foot = 0.3048 meters, 1 inch = 0.0254 meters
      return (feet * 0.3048) + (inches * 0.0254);
    } else {
      // Convert from centimeters to meters: 1 cm = 0.01 meters
      final centimeters = double.tryParse(input);
      if (centimeters == null) {
        throw const FormatException('Invalid format for centimeters.');
      }
      return centimeters * 0.01;
    }
  }
}
