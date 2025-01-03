import 'dart:io';
import 'package:daily_weight_logs_mobile/common/constants/api_response.dart';
import 'package:daily_weight_logs_mobile/common/constants/endpoints.dart';
import 'package:daily_weight_logs_mobile/common/utils/error_parser.dart';
import 'package:daily_weight_logs_mobile/features/authentication/domain/auth_model.dart';
import 'package:daily_weight_logs_mobile/features/authentication/domain/login_auth_request.dart';
import 'package:daily_weight_logs_mobile/features/authentication/domain/register_auth_model.dart';
import 'package:daily_weight_logs_mobile/services/api_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  Future<(ApiSuccess<AuthApiResponse>?, ApiError?)> login(
      LoginAuthRequest request) async {
    const loginUrl = baseUrl + loginWithEmailUrl;
    try {
      final response = await APIService.post(
        url: loginUrl,
        body: request.toJson(),
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
      debugPrint('DioException: $dioError');
      return (
        null,
        ApiError(
          statusCode: 500,
          message: 'An unexpected error occurred.',
        )
      );
    } catch (e, stackTrace) {
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
    try {
      final response = await APIService.post(
        url: registerUrl,
        body: request.toJson(),
      );

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
    // const forgotPasswordUrl = baseUrl + forgotPasswordEndpoint;
    try {
      final response = await APIService.post(
        url: '',
        body: {'email': email},
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
