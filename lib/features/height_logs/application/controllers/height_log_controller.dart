import 'package:daily_weight_logs_mobile/common/constants/api_response.dart';
import 'package:daily_weight_logs_mobile/common/utils/weight_log_secure_storage.dart';
import 'package:daily_weight_logs_mobile/features/height_logs/data/repositories/height_log_repository.dart';
import 'package:daily_weight_logs_mobile/features/height_logs/domain/models/height_log_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HeightLogController extends StateNotifier<AsyncValue<HeightLog?>> {
  final HeightLogRepository repository;

  HeightLogController(this.repository) : super(const AsyncData(null));

  /// Fetch Height Logs
  Future<void> fetchUserHeightLog() async {
    final String? userId =
        await DailyWeightLogsSecureStorage().getUserId(); // Fetch user ID
    debugPrint('User ID: $userId');

    state = const AsyncLoading(); // Set state to loading

    final (HeightLogApiResponse? apiResponse, String? errorMessage) =
        await repository.fetchHeightLogByUserId(userId ?? '');

    if (apiResponse != null && apiResponse.data != null) {
      state = AsyncValue.data(apiResponse.data);
    } else {
      state = AsyncValue.error(
        errorMessage ?? 'An unexpected error occurred',
        StackTrace.current,
      );
    }
  }

  Future<void> saveHeightLog(String height, String weightGoal) async {
    state = const AsyncLoading();

    final (ApiSuccess<HeightLogApiResponse>? res, ApiError? err) =
        await repository
            .saveHeightLog(HeightLog(height: height, weightGoal: weightGoal));

    if (res != null) {
      state = AsyncValue.data(res.data?.data);
    } else if (err != null) {
      state = AsyncValue.error(err.message, StackTrace.current);
    }

    // fetchHeightLogs();
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
  (ref) => HeightLogController(HeightLogRepository()),
);
