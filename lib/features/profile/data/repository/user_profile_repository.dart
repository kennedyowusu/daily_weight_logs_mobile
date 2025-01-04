import 'package:daily_weight_logs_mobile/common/constants/api_response.dart';
import 'package:daily_weight_logs_mobile/common/constants/endpoints.dart';
import 'package:daily_weight_logs_mobile/common/utils/error_parser.dart';
import 'package:daily_weight_logs_mobile/features/profile/domain/model/user_profile_model.dart';
import 'package:daily_weight_logs_mobile/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileRepository {
  final String profile = baseUrl + profileUrl;

  Future<(ApiSuccess<UserProfile>?, ApiError?)> fetchUserProfileById() async {
    try {
      final response = await APIService.get(url: profile);

      if (response.statusCode == 200) {
        final decodedRes = UserProfile.fromJson(response.data['data']);

        return (
          ApiSuccess<UserProfile>(
            statusCode: response.statusCode ?? 0,
            data: decodedRes,
          ),
          null
        );
      } else {
        return (
          null,
          ApiError(
            statusCode: response.statusCode ?? 0,
            message: errorParser(response.data),
          )
        );
      }
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
      return (
        null,
        ApiError(
          statusCode: 500,
          message: 'Error fetching user profile, $e',
        )
      );
    }
  }
}

final userProfileRepositoryProvider = Provider<UserProfileRepository>(
  (ref) => UserProfileRepository(),
);
