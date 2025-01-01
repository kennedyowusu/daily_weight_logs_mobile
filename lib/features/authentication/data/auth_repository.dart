import 'package:daily_weight_logs_mobile/features/authentication/domain/auth_model.dart';
import 'package:daily_weight_logs_mobile/features/authentication/domain/login_auth_request.dart';
import 'package:daily_weight_logs_mobile/features/authentication/domain/register_auth_model.dart';
import 'package:dio/dio.dart';
import 'package:daily_weight_logs_mobile/common/constants/api_response.dart';
import 'package:daily_weight_logs_mobile/common/utils/error_parser.dart';

class AuthRepository {
  final Dio dio;

  AuthRepository(this.dio);

  Future<(ApiSuccess<AuthApiResponse>?, ApiError?)> login(
      LoginAuthRequest request) async {
    try {
      final response = await dio.post(
        '/api/v1/login',
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
    } catch (e) {
      return (
        null,
        ApiError(
          statusCode: 500,
          message: 'Error during login',
        )
      );
    }
  }

  Future<(ApiSuccess<AuthApiResponse>?, ApiError?)> register(
      RegisterAuthRequest request) async {
    try {
      final response = await dio.post(
        '/api/v1/register',
        data: request.toJson(),
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
    } catch (e) {
      return (
        null,
        ApiError(
          statusCode: 500,
          message: 'Error during registration',
        )
      );
    }
  }
}
