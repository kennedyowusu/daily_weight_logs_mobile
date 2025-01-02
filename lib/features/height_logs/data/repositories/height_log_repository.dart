import 'dart:io';
import 'package:daily_weight_logs_mobile/common/constants/endpoints.dart';
import 'package:daily_weight_logs_mobile/common/utils/error_parser.dart';
import 'package:daily_weight_logs_mobile/features/height_logs/domain/models/height_log_model.dart';
import 'package:dio/dio.dart';

class HeightLogRepository {
  final Dio dio;
  final String combinedUrl = baseUrl + healthDataUrl;

  HeightLogRepository(this.dio);

  Future<(HeightLogApiResponse?, String?)> fetchHeightLogs() async {
    final String healthLogUrl = combinedUrl;

    try {
      final response = await dio.get(healthLogUrl);

      if (response.statusCode == 200) {
        final apiResponse = HeightLogApiResponse.fromJson(response.data);
        return (apiResponse, null);
      } else {
        return (null, errorParser(response.data));
      }
    } on DioException catch (dioError) {
      if (dioError.error is SocketException) {
        return (null, 'No internet connection. Please try again.');
      }
      return (null, 'An unexpected error occurred.');
    } catch (e) {
      return (null, 'An unexpected error occurred.');
    }
  }

  Future<(HeightLogApiResponse?, String?)> saveHeightLog(
      HeightLog heightLog) async {
    final String createHealthLogUrl = combinedUrl;
    try {
      final response = await dio.post(
        createHealthLogUrl,
        data: heightLog.toJson(),
      );

      if (response.statusCode == 201) {
        final apiResponse = HeightLogApiResponse.fromJson(response.data);
        return (apiResponse, null);
      } else {
        return (null, errorParser(response.data));
      }
    } on DioException catch (dioError) {
      if (dioError.error is SocketException) {
        return (null, 'No internet connection. Please try again.');
      }
      return (null, 'An unexpected error occurred.');
    } catch (e) {
      return (null, 'An unexpected error occurred.');
    }
  }

  Future<(HeightLogApiResponse?, String?)> updateHeightLog(
      HeightLog heightLog) async {
    final String updateHealthLogUrl = combinedUrl;
    try {
      final response = await dio.put(
        updateHealthLogUrl,
        data: heightLog.toJson(),
      );

      if (response.statusCode == 200) {
        final apiResponse = HeightLogApiResponse.fromJson(response.data);
        return (apiResponse, null);
      } else {
        return (null, errorParser(response.data));
      }
    } on DioException catch (dioError) {
      if (dioError.error is SocketException) {
        return (null, 'No internet connection. Please try again.');
      }
      return (null, 'An unexpected error occurred.');
    } catch (e) {
      return (null, 'An unexpected error occurred.');
    }
  }

  Future<(HeightLogApiResponse?, String?)> deleteHeightLog(String id) async {
    final String deleteHealthLogUrl = combinedUrl;
    try {
      final response = await dio.delete(
        deleteHealthLogUrl,
        queryParameters: {'id': id},
      );

      if (response.statusCode == 200) {
        final apiResponse = HeightLogApiResponse.fromJson(response.data);
        return (apiResponse, null);
      } else {
        return (null, errorParser(response.data));
      }
    } on DioException catch (dioError) {
      if (dioError.error is SocketException) {
        return (null, 'No internet connection. Please try again.');
      }
      return (null, 'An unexpected error occurred.');
    } catch (e) {
      return (null, 'An unexpected error occurred.');
    }
  }
}
