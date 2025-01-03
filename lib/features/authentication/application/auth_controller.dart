import 'package:daily_weight_logs_mobile/common/utils/weight_log_secure_storage.dart';
import 'package:daily_weight_logs_mobile/features/authentication/domain/auth_model.dart';
import 'package:daily_weight_logs_mobile/features/authentication/domain/login_auth_request.dart';
import 'package:daily_weight_logs_mobile/features/authentication/domain/register_auth_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_weight_logs_mobile/common/constants/api_response.dart';
import '../data/auth_repository.dart';

class AuthController extends StateNotifier<AsyncValue<AuthApiResponse?>> {
  final AuthRepository repository;
  final DailyWeightLogsSecureStorage secureStorage =
      DailyWeightLogsSecureStorage();

  AuthController(this.repository) : super(const AsyncData(null));

  Future<AuthApiResponse?> login(String email, String password) async {
    state = const AsyncLoading();

    final (ApiSuccess<AuthApiResponse>? success, ApiError? error) =
        await repository
            .login(LoginAuthRequest(email: email, password: password));

    if (success != null) {
      final authResponse = success.data;

      debugPrint('User ID: ${authResponse?.user?.id}');

      // Store the access token and user ID
      if (authResponse?.token != null && authResponse?.user?.id != null) {
        await secureStorage.storeAccessToken(authResponse!.token!);
        await secureStorage.storeUserId(authResponse.user!.id!.toString());
      }

      state = AsyncValue.data(success.data);
      return success.data;
    } else if (error != null) {
      state = AsyncValue.error(error.message, StackTrace.current);
    }
    return null;
  }

  /// Handle user registration
  Future<void> register(
    String name,
    String username,
    String email,
    String country,
    String password,
    String passwordConfirmation,
  ) async {
    state = const AsyncLoading();
    final (ApiSuccess<AuthApiResponse>? res, ApiError? err) =
        await repository.register(RegisterAuthRequest(
      name: name,
      username: username,
      email: email,
      country: country,
      password: password,
      passwordConfirmation: passwordConfirmation,
    ));

    if (res != null) {
      // Set state to successful response
      state = AsyncValue.data(res.data);

      // Save token or user details locally (e.g., in secure storage)
      if (res.data!.token != null) {
        await secureStorage.storeAccessToken(res.data?.token ?? '');
      }
    } else if (err != null) {
      // Set state to error
      state = AsyncValue.error(err.message, StackTrace.current);
    }
  }

  Future<void> forgotPassword(String email) async {
    state = const AsyncLoading();
    final (ApiSuccess<AuthApiResponse>? res, ApiError? err) =
        await repository.forgotPassword(email);

    if (res != null) {
      // Set state to successful response
      state = AsyncValue.data(res.data);
    } else if (err != null) {
      // Set state to error
      state = AsyncValue.error(err.message, StackTrace.current);
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();

    try {
      // Clear stored access token and user ID
      await secureStorage.deleteAccessToken();
      await secureStorage.deleteUserId();

      // Reset state to null after logout
      state = const AsyncData(null);

      debugPrint('User logged out successfully');
    } catch (e, stackTrace) {
      state = AsyncValue.error(e.toString(), stackTrace);
      debugPrint('Error during logout: $e');
    }
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<AuthApiResponse?>>(
  (ref) => AuthController(ref.watch(authRepositoryProvider)),
);

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(),
);
