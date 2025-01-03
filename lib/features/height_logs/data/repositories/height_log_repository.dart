import 'package:daily_weight_logs_mobile/common/constants/api_response.dart';
import 'package:daily_weight_logs_mobile/common/constants/endpoints.dart';
import 'package:daily_weight_logs_mobile/common/utils/error_parser.dart';
import 'package:daily_weight_logs_mobile/features/height_logs/domain/models/height_log_model.dart';
import 'package:daily_weight_logs_mobile/services/api_services.dart';
import 'package:flutter/material.dart';

class HeightLogRepository {
  final String healthLogUrl = baseUrl + healthDataUrl;

  Future<(HeightLogApiResponse?, String?)> fetchHeightLogs() async {
    debugPrint('Fetching height logs from: $healthLogUrl');
    try {
      final response = await APIService.get(url: healthLogUrl);

      if (response.statusCode == 200) {
        final apiResponse = HeightLogApiResponse.fromJson(response.data);
        return (apiResponse, null);
      } else {
        return (null, errorParser(response.data));
      }
    } catch (e) {
      return (null, 'An unexpected error occurred: $e');
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
