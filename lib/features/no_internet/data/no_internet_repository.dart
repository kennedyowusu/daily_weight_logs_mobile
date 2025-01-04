import 'package:connectivity_plus/connectivity_plus.dart';

class NoInternetRepository {
  final Connectivity _connectivity = Connectivity();

  Stream<List<ConnectivityResult>> get connectivityStream =>
      _connectivity.onConnectivityChanged;

  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
