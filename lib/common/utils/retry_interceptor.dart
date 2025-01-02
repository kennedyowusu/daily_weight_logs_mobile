import 'package:daily_weight_logs_mobile/common/constants/endpoints.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int defaultMaxRetries;
  final int defaultRetryDelayMilliseconds;

  RetryInterceptor({
    required this.dio,
    this.defaultMaxRetries = 3,
    this.defaultRetryDelayMilliseconds = 1000,
  });

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    // Check if the request can be retried
    if (_shouldRetry(err)) {
      int retries = 0;

      // Get endpoint-specific retry configuration
      final retryConfig = _getRetryConfig(err.requestOptions.path);
      final maxRetries = retryConfig['maxRetries'] ?? defaultMaxRetries;
      final retryDelayMilliseconds =
          retryConfig['retryDelay'] ?? defaultRetryDelayMilliseconds;

      while (retries < maxRetries) {
        retries++;
        debugPrint(
            'Retrying ${err.requestOptions.path}, attempt $retries/$maxRetries');

        // Wait before retrying
        await Future.delayed(Duration(milliseconds: retryDelayMilliseconds));

        try {
          // Retry the request
          final response = await dio.request(
            err.requestOptions.path,
            options: Options(
              method: err.requestOptions.method,
              headers: err.requestOptions.headers,
              sendTimeout: const Duration(milliseconds: 7000),
              receiveTimeout: const Duration(milliseconds: 7000),
            ),
            data: err.requestOptions.data,
            queryParameters: err.requestOptions.queryParameters,
          );
          return handler.resolve(response);
        } catch (e) {
          debugPrint('Retry attempt $retries failed: $e');

          // Break if max retries are reached
          if (retries == maxRetries) break;
        }
      }
    }

    // If retries are exhausted or not allowed, pass the error
    return handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    // Retry logic based on error type
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      return true;
    }

    // Retry logic based on endpoint
    final retryEndpoints = [
      loginWithEmailUrl,
      signUpWithEmailUrl,
      logoutUrl,
      profileUrl,
      updateProfileUrl,
      deleteProfileUrl,
      weightLogsUrl,
      createWeightLogUrl,
      updateWeightLogUrl,
      deleteWeightLogUrl,
      healthDataUrl,
      createHealthDataUrl,
      updateHealthDataUrl,
      deleteHealthDataUrl,
    ];
    final requestPath = err.requestOptions.path;

    if (retryEndpoints.any((endpoint) => requestPath.contains(endpoint))) {
      return true;
    }

    return false; // Do not retry for other conditions
  }

  Map<String, int> _getRetryConfig(String path) {
    final retryConfig = {
      loginWithEmailUrl: {'maxRetries': 3, 'retryDelay': 1000},
      weightLogsUrl: {'maxRetries': 5, 'retryDelay': 500},
    };

    return retryConfig[path] ?? {}; // Return specific config or default
  }
}
