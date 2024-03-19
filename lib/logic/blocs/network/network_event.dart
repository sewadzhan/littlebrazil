part of 'network_bloc.dart';

abstract class NetworkEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ConnectionChanged extends NetworkEvent {
  final NetworkState connection;
  ConnectionChanged(this.connection);

  @override
  List<Object> get props => [connection];
}

class ConnectionInitialChecked extends NetworkEvent {}
