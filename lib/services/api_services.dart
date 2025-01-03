import 'package:daily_weight_logs_mobile/common/constants/app_key.dart';
import 'package:daily_weight_logs_mobile/common/constants/endpoints.dart';
import 'package:daily_weight_logs_mobile/common/utils/error_parser.dart';
import 'package:daily_weight_logs_mobile/common/utils/retry_interceptor.dart';
import 'package:daily_weight_logs_mobile/common/utils/secure_storage.dart';
import 'package:daily_weight_logs_mobile/features/authentication/presentation/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class APIService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 5000),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      validateStatus: (status) {
        return status != null && status >= 200 && status < 500;
      },
    ),
  );

  static void initializeInterceptors() {
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        defaultMaxRetries: 3,
        defaultRetryDelayMilliseconds: 1000,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          await _logoutUserOn401Error(error);
          return handler.next(error);
        },
      ),
    );
  }

  static Future<void> _logoutUserOn401Error(DioException error) async {
    if (error.response?.statusCode == 401 &&
        errorParser(error.response?.data) == "Invalid token.") {
      String authToken = await DailyWeightLogsSecureStorage().getAccessToken();

      if (authToken.isNotEmpty) {
        await DailyWeightLogsSecureStorage().deleteAccessToken();

        Future.delayed(const Duration(seconds: 3), () {
          if (appNavigatorKey.currentState != null) {
            appNavigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            );
          }
        });
      }
    }
  }

  static Future<Response> _request({
    required String method,
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    String accessToken = await DailyWeightLogsSecureStorage().getAccessToken();
    bool isAuth = accessToken.isNotEmpty;

    if (isAuth) {
      _dio.options.headers['Authorization'] = 'Bearer $accessToken';
    } else {
      _dio.options.headers.remove('Authorization');
    }

    try {
      Response response;
      switch (method.toUpperCase()) {
        case 'POST':
          response = await _dio.post(url, data: body);
          break;
        case 'PATCH':
          response = await _dio.patch(url, data: body);
          break;
        case 'PUT':
          response = await _dio.put(url, data: body);
          break;
        case 'DELETE':
          response = await _dio.delete(url, queryParameters: queryParameters);
          break;
        case 'GET':
        default:
          response = await _dio.get(url, queryParameters: queryParameters);
          break;
      }
      return response;
    } on DioException catch (error) {
      await _logoutUserOn401Error(error);
      rethrow;
    }
  }

  static Future<Response> post({
    required String url,
    Map<String, dynamic>? body,
  }) {
    return _request(method: 'POST', url: url, body: body);
  }

  static Future<Response> patch({
    required String url,
    Map<String, dynamic>? body,
  }) {
    return _request(method: 'PATCH', url: url, body: body);
  }

  static Future<Response> put({
    required String url,
    Map<String, dynamic>? body,
  }) {
    return _request(method: 'PUT', url: url, body: body);
  }

  static Future<Response> delete({
    required String url,
    Map<String, dynamic>? queryParameters,
  }) {
    return _request(
        method: 'DELETE', url: url, queryParameters: queryParameters);
  }

  static Future<Response> get({
    required String url,
    Map<String, dynamic>? queryParameters,
  }) {
    return _request(method: 'GET', url: url, queryParameters: queryParameters);
  }

  static Future<Response> login({
    required String email,
    required String password,
  }) {
    return post(
      url: 'loginUrl',
      body: {
        'email': email,
        'password': password,
      },
    );
  }

  static Future<Response> register({
    required String email,
    required String password,
    required String name,
  }) {
    return post(
      url: 'registerUrl',
      body: {
        'email': email,
        'password': password,
        'name': name,
      },
    );
  }
}
