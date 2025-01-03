import 'dart:io';
import 'package:daily_weight_logs_mobile/common/constants/endpoints.dart';
import 'package:daily_weight_logs_mobile/features/authentication/domain/auth_model.dart';
import 'package:daily_weight_logs_mobile/features/authentication/domain/login_auth_request.dart';
import 'package:daily_weight_logs_mobile/features/authentication/domain/register_auth_model.dart';
import 'package:dio/dio.dart';
import 'package:daily_weight_logs_mobile/common/constants/api_response.dart';
import 'package:daily_weight_logs_mobile/common/utils/error_parser.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  final Dio dio;

  AuthRepository(this.dio);

  Future<(ApiSuccess<AuthApiResponse>?, ApiError?)> login(
      LoginAuthRequest request) async {
    const loginUrl = baseUrl + loginWithEmailUrl;
    try {
      final response = await dio.post(
        loginUrl,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        final authResponse = AuthApiResponse.fromJson(response.data);
        return (
          ApiSuccess<AuthApiResponse>(
            statusCode: response.statusCode!,
            data: authResponse,
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
    } on DioException catch (dioError) {
      // Check if it's a socket exception
      if (dioError.error is SocketException) {
        debugPrint('SocketException: No internet connection');
        return (
          null,
          ApiError(
            statusCode: 500,
            message: 'No internet connection. Please try again.',
          )
        );
      }
      // Handle other DioErrors
      debugPrint('DioException: $dioError');
      return (
        null,
        ApiError(
          statusCode: 500,
          message: 'An unexpected error occurred.',
        )
      );
    } catch (e, stackTrace) {
      // Log the error
      debugPrint('Error during login: $e');
      debugPrint('StackTrace: $stackTrace');
      return (
        null,
        ApiError(
          statusCode: 500,
          message: 'An unexpected error occurred.',
        )
      );
    }
  }

  Future<(ApiSuccess<AuthApiResponse>?, ApiError?)> register(
      RegisterAuthRequest request) async {
    const registerUrl = baseUrl + signUpWithEmailUrl;
    debugPrint('Register URL: $registerUrl');
    try {
      final response = await dio.post(
        registerUrl,
        data: request.toJson(),
      );

      debugPrint('Response: ${response.data}');
      debugPrint('Response Status: ${response.statusCode}');

      if (response.statusCode == 201) {
        final authResponse = AuthApiResponse.fromJson(response.data);
        return (
          ApiSuccess<AuthApiResponse>(
            statusCode: response.statusCode!,
            data: authResponse,
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
    } on DioException catch (dioError) {
      debugPrint('Request URL: ${dioError.requestOptions.uri}');
      debugPrint('Request Headers: ${dioError.requestOptions.headers}');
      debugPrint('Request Body: ${dioError.requestOptions.data}');
      debugPrint('DioException: $dioError');

      // Check if it's a socket exception
      if (dioError.error is SocketException) {
        debugPrint('SocketException: No internet connection');
        return (
          null,
          ApiError(
            statusCode: 500,
            message: 'No internet connection. Please try again.',
          )
        );
      }
      // Handle other DioErrors
      debugPrint('DioException: $dioError');
      return (
        null,
        ApiError(
          statusCode: 500,
          message: 'An unexpected error occurred.',
        )
      );
    } catch (e, stackTrace) {
      debugPrint('Error during registration: $e');
      debugPrint('StackTrace: $stackTrace');
      return (
        null,
        ApiError(
          statusCode: 500,
          message: 'An unexpected error occurred.',
        )
      );
    }
  }

  Future<(ApiSuccess<AuthApiResponse>?, ApiError?)> forgotPassword(
      String email) async {
    try {
      final response = await dio.post(
        '/api/v1/forgot-password',
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        final authResponse = AuthApiResponse.fromJson(response.data);
        return (
          ApiSuccess<AuthApiResponse>(
            statusCode: response.statusCode!,
            data: authResponse,
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
    } on DioException catch (dioError) {
      // Check if it's a socket exception
      if (dioError.error is SocketException) {
        debugPrint('SocketException: No internet connection');
        return (
          null,
          ApiError(
            statusCode: 500,
            message: 'No internet connection. Please try again.',
          )
        );
      }
      // Handle other DioErrors
      debugPrint('DioException: $dioError');
      return (
        null,
        ApiError(
          statusCode: 500,
          message: 'An unexpected error occurred.',
        )
      );
    } catch (e) {
      return (
        null,
        ApiError(
          statusCode: 500,
          message: 'Error during forgot password',
        )
      );
    }
  }
}
