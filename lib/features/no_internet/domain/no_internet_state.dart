import 'package:equatable/equatable.dart';

enum ConnectivityStatus { connected, disconnected }

class NoInternetState extends Equatable {
  final ConnectivityStatus status;

  const NoInternetState({required this.status});

  factory NoInternetState.connected() =>
      const NoInternetState(status: ConnectivityStatus.connected);

  factory NoInternetState.disconnected() =>
      const NoInternetState(status: ConnectivityStatus.disconnected);

  @override
  List<Object?> get props => [status];
}
