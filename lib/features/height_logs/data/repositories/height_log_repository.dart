import 'package:daily_weight_logs_mobile/common/constants/api_response.dart';
import 'package:daily_weight_logs_mobile/common/constants/endpoints.dart';
import 'package:daily_weight_logs_mobile/common/utils/error_parser.dart';
import 'package:daily_weight_logs_mobile/features/height_logs/domain/models/height_log_model.dart';
import 'package:daily_weight_logs_mobile/services/api_services.dart';
import 'package:flutter/material.dart';

class HeightLogRepository {
  final String healthLogUrl = baseUrl + healthDataUrl;

  Future<String?> getHealthDataIdByUserId(String userId) async {
    final String url = '$baseUrl/user-health-data/$userId';
    debugPrint('Fetching healthData ID for user $userId from: $url');
    try {
      final response = await APIService.get(url: url);

      if (response.statusCode == 200) {
        return response.data['id'];
      } else {
        debugPrint('Error Response Data: ${response.data}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching healthData ID: $e');
      return null;
    }
  }

  Future<(ApiSuccess<HeightLogApiResponse>?, ApiError?)> saveHeightLog(
      HeightLog heightLog) async {
    debugPrint('Saving height log to: $healthLogUrl');
    try {
      final response = await APIService.post(
        url: healthLogUrl,
        body: heightLog.toJson(),
      );

      if (response.statusCode == 201) {
        final apiResponse = HeightLogApiResponse.fromJson(response.data);
        return (
          ApiSuccess<HeightLogApiResponse>(
            statusCode: response.statusCode!,
            data: apiResponse,
          ),
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
}
