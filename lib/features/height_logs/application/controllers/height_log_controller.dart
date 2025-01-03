import 'package:daily_weight_logs_mobile/common/constants/api_response.dart';
import 'package:daily_weight_logs_mobile/common/utils/weight_log_secure_storage.dart';
import 'package:daily_weight_logs_mobile/features/height_logs/data/repositories/height_log_repository.dart';
import 'package:daily_weight_logs_mobile/features/height_logs/domain/models/height_log_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HeightLogController extends StateNotifier<AsyncValue<HeightLog?>> {
  final HeightLogRepository repository;

  HeightLogController(this.repository) : super(const AsyncData(null));

  // Fetch User Health Data
  Future<void> fetchUserHealthData() async {
    state = const AsyncLoading(); // Set loading state

    try {
      // Step 1: Fetch the user ID from secure storage
      final String? userId = await DailyWeightLogsSecureStorage().getUserId();
      if (userId == null) {
        state = AsyncValue.error('User ID not found', StackTrace.current);
        return;
      }

      // Step 2: Fetch the health data for the user
      final HeightLog? heightLog =
          await repository.getHealthDataByUserId(userId);

      if (heightLog != null) {
        // Successfully fetched health data
        state = AsyncValue.data(heightLog);
      } else {
        // Error fetching health data
        state = AsyncValue.error(
            'Failed to fetch health data.', StackTrace.current);
      }
    } catch (e, stackTrace) {
      // Handle unexpected errors
      state = AsyncValue.error('An unexpected error occurred: $e', stackTrace);
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
