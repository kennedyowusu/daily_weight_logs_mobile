import 'package:daily_weight_logs_mobile/common/constants/api_response.dart';
import 'package:daily_weight_logs_mobile/common/constants/endpoints.dart';
import 'package:daily_weight_logs_mobile/common/utils/error_parser.dart';
import 'package:daily_weight_logs_mobile/features/height_logs/domain/models/height_log_model.dart';
import 'package:daily_weight_logs_mobile/services/api_services.dart';
import 'package:flutter/material.dart';

class HeightLogRepository {
  final String healthLogUrl = baseUrl + healthDataUrl;

  Future<HeightLog?> getHealthDataByUserId(String userId) async {
    final String url = '$baseUrl/user-health-data/$userId';
    debugPrint('Fetching healthData for user $userId from: $url');
    try {
      final response = await APIService.get(url: url);

      debugPrint('Response health data log: ${response.data}');

      if (response.statusCode == 200) {
        return HeightLogApiResponse.fromJson(response.data)
            .data; // Parse the response into a HeightLog object
      } else {
        debugPrint('Error Response Data: ${response.data}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching healthData: $e');
      return null;
    }
  }

  Future<(ApiSuccess<HeightLogApiResponse>?, ApiError?)> saveHeightLog(
      HeightLog heightLog) async {
    debugPrint('Saving height log to: $healthLogUrl');
    try {
      final response = await APIService.post(
        url: 'https://weightlogapi.kennedyowusu.com/api/v1/health-data',
        // baseUrl + createHealthDataUrl,
        body: heightLog.toJson(),
      );

      debugPrint('Response health data log: ${response.data}');

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
