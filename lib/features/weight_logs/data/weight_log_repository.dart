import 'package:daily_weight_logs_mobile/common/constants/endpoints.dart';
import 'package:daily_weight_logs_mobile/common/utils/error_parser.dart';
import 'package:daily_weight_logs_mobile/features/weight_logs/domain/weight_log.dart';
import 'package:daily_weight_logs_mobile/common/constants/api_response.dart';
import 'package:daily_weight_logs_mobile/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeightLogRepository {
  final String weightDataUrl = baseUrl + weightLogsUrl;

  Future<(ApiSuccess<List<WeightLogModel>>?, ApiError?)>
      fetchWeightLogs() async {
    try {
      final response = await APIService.get(url: weightDataUrl);

      if (response.statusCode == 200) {
        final decodedRes = (response.data as List)
            .map((log) => WeightLogModel.fromJson(log))
            .toList();
        return (
          ApiSuccess<List<WeightLogModel>>(
            statusCode: response.statusCode ?? 0,
            data: decodedRes,
          ),
          null
        );
      } else {
        return (
          null,
          ApiError(
            statusCode: response.statusCode ?? 0,
            message: errorParser(response.data),
          )
        );
      }
    } catch (e) {
      return (
        null,
        ApiError(
          statusCode: 500,
          message: 'Error fetching weight logs',
        )
      );
    }
  }

  Future<(ApiSuccess<void>?, ApiError?)> addWeightLog({
    required int weight,
    required String timeOfDay,
    required String loggedAt,
  }) async {
    debugPrint('Adding weight log to: $weightDataUrl');
    try {
      final response = await APIService.post(
        url: weightDataUrl,
        body: {
          "weight": weight,
          "time_of_day": timeOfDay.toLowerCase(),
          "logged_at": loggedAt,
        },
      );

      debugPrint('Response: ${response.data}');

      if (response.statusCode == 201) {
        return (
          ApiSuccess<void>(statusCode: response.statusCode!, data: null),
          null
        );
      } else {
        return (
          null,
          ApiError(
            statusCode: response.statusCode!,
            message: errorParser(response.data),
          )
        );
      }
    } catch (e) {
      return (
        null,
        ApiError(
          statusCode: 500,
          message: 'An unexpected error occurred: $e',
        )
      );
    }
  }

  Future<(ApiSuccess<void>?, ApiError?)> deleteWeightLog({
    required int logId,
  }) async {
    try {
      final response = await APIService.delete(
        url: '/api/v1/weight-logs/$logId',
      );

      if (response.statusCode == 200) {
        return (
          ApiSuccess<void>(
            statusCode: response.statusCode ?? 0,
            data: null,
          ),
          null
        );
      } else {
        return (
          null,
          ApiError(
            statusCode: response.statusCode ?? 0,
            message: errorParser(response.data),
          )
        );
      }
    } catch (e) {
      return (
        null,
        ApiError(
          statusCode: 500,
          message: 'Error deleting weight log',
        )
      );
    }
  }
}

final weightLogRepositoryProvider = Provider((ref) => WeightLogRepository());
