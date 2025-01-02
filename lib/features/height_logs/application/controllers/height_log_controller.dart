import 'package:daily_weight_logs_mobile/features/height_logs/data/repositories/height_log_repository.dart';

class HeightLogController {
  final HeightLogRepository repository;

  HeightLogController({required this.repository});

  Future<void> submitHeightLog(double height, String weightGoal) async {
    await repository.saveHeightLog(height, weightGoal);
  }
}
