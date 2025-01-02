import 'package:daily_weight_logs_mobile/features/height_logs/data/repositories/height_log_repository.dart';
import 'package:daily_weight_logs_mobile/features/height_logs/domain/models/height_log_model.dart';
import 'package:dio/dio.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class HeightLogController extends StateNotifier<AsyncValue<HeightLog?>> {
  final HeightLogRepository repository;

  HeightLogController(this.repository) : super(const AsyncData(null));

  Future<void> fetchHeightLogs() async {
    state = const AsyncLoading();

    final (apiResponse, errorMessage) = await repository.fetchHeightLogs();
    if (apiResponse != null) {
      state = AsyncValue.data(apiResponse.data);
    } else {
      state =
          AsyncValue.error(errorMessage ?? 'Unknown error', StackTrace.current);
    }
  }

  Future<void> saveHeightLog(double height, String weightGoal) async {
    state = const AsyncLoading();

    final newHeightLog = HeightLog(
      height: height.toString(),
      weightGoal: weightGoal,
    );

    final (apiResponse, errorMessage) =
        await repository.saveHeightLog(newHeightLog);

    if (apiResponse != null) {
      state = AsyncValue.data(apiResponse.data);
    } else {
      state =
          AsyncValue.error(errorMessage ?? 'Unknown error', StackTrace.current);
    }
  }

  double convertToMeters(String input, {bool isUsingFeet = false}) {
    if (isUsingFeet) {
      final parts = input.split('.');
      if (parts.isEmpty || parts.length > 2) {
        throw const FormatException('Invalid format for feet and inches.');
      }

      final feet = double.tryParse(parts[0]) ?? 0.0;
      final inches = parts.length == 2 ? double.tryParse(parts[1]) ?? 0.0 : 0.0;

      return (feet * 0.3048) + (inches * 0.0254);
    } else {
      final centimeters = double.tryParse(input);
      if (centimeters == null) {
        throw const FormatException('Invalid format for centimeters.');
      }
      return centimeters * 0.01;
    }
  }
}

final heightLogControllerProvider =
    StateNotifierProvider<HeightLogController, AsyncValue<HeightLog?>>(
  (ref) => HeightLogController(HeightLogRepository(Dio())),
);
