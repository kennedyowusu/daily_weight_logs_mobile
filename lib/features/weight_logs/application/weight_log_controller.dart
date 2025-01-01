import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/weight_log_repository.dart';
import '../domain/weight_log.dart';
import 'package:daily_weight_logs_mobile/common/constants/api_response.dart';

class WeightLogController
    extends StateNotifier<AsyncValue<List<WeightLogModel>>> {
  final WeightLogRepository repository;

  WeightLogController(this.repository) : super(const AsyncLoading()) {
    fetchWeightLogs();
  }

  Future<void> fetchWeightLogs() async {
    state = const AsyncLoading(); // Reset state to loading while fetching
    final (ApiSuccess<List<WeightLogModel>>? res, ApiError? err) =
        await repository.fetchWeightLogs();

    if (res != null) {
      state = AsyncValue.data(res.data!); // Update state with fetched data
    } else if (err != null) {
      state = AsyncValue.error(err.message, StackTrace.current); // Handle error
    }
  }

  Future<void> addWeightLog({
    required int weight,
    required String timeOfDay,
    required String loggedAt,
  }) async {
    final (ApiSuccess<void>? res, ApiError? err) =
        await repository.addWeightLog(
      weight: weight,
      timeOfDay: timeOfDay,
      loggedAt: loggedAt,
    );

    if (res != null) {
      // If adding weight log succeeds, refetch the logs
      await fetchWeightLogs();
    } else if (err != null) {
      // Handle error if adding weight log fails
      state = AsyncValue.error(err.message, StackTrace.current);
    }
  }

  Future<void> deleteWeightLog({required int logId}) async {
    final (ApiSuccess<void>? res, ApiError? err) =
        await repository.deleteWeightLog(
      logId: logId,
    );

    if (res != null) {
      // If deleting weight log succeeds, refetch the logs
      await fetchWeightLogs();
    } else if (err != null) {
      // Handle error if deleting weight log fails
      state = AsyncValue.error(err.message, StackTrace.current);
    }
  }
}

final weightLogControllerProvider = StateNotifierProvider<WeightLogController,
    AsyncValue<List<WeightLogModel>>>(
  (ref) => WeightLogController(ref.watch(weightLogRepositoryProvider)),
);

final weightLogRepositoryProvider =
    Provider((ref) => WeightLogRepository(Dio()));
