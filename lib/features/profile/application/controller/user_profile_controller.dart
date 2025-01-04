import 'package:daily_weight_logs_mobile/features/profile/data/repository/user_profile_repository.dart';
import 'package:daily_weight_logs_mobile/features/profile/domain/model/user_profile_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:daily_weight_logs_mobile/common/constants/api_response.dart';

class UserProfileController extends StateNotifier<AsyncValue<UserProfile?>> {
  final UserProfileRepository repository;

  UserProfileController(this.repository) : super(const AsyncLoading()) {
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    state = const AsyncLoading(); // Reset state to loading while fetching

    final (ApiSuccess<UserProfile>? res, ApiError? err) =
        await repository.fetchUserProfileById();

    if (res != null && res.data != null) {
      state = AsyncValue.data(res.data);
    } else if (err != null) {
      state = AsyncValue.error(err.message, StackTrace.current);
    }
  }
}

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, AsyncValue<UserProfile?>>(
  (ref) => UserProfileController(ref.watch(userProfileRepositoryProvider)),
);
