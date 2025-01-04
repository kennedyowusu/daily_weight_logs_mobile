import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/no_internet_repository.dart';
import '../domain/no_internet_state.dart';

final noInternetControllerProvider =
    StateNotifierProvider<NoInternetController, NoInternetState>(
  (ref) => NoInternetController(
    ref.read(noInternetRepositoryProvider),
  ),
);

final noInternetRepositoryProvider = Provider((_) => NoInternetRepository());

class NoInternetController extends StateNotifier<NoInternetState> {
  final NoInternetRepository repository;

  NoInternetController(this.repository) : super(NoInternetState.connected()) {
    _monitorConnectivity();
  }

  void _monitorConnectivity() {
    repository.connectivityStream.listen((result) {
      if (result == ConnectivityResult.none) {
        state = NoInternetState.disconnected();
      } else {
        state = NoInternetState.connected();
      }
    });
  }
}
