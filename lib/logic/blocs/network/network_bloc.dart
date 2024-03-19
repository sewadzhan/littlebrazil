import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'network_event.dart';
part 'network_state.dart';

//Bloc for checking internet network
class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  StreamSubscription? _subscription;

  NetworkBloc() : super(ConnectionInitial()) {
    on<ConnectionInitialChecked>(connectionInitialCheckedToState);
    on<ConnectionChanged>(connectionChangedToState);
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      var result = await InternetConnectionChecker().hasConnection;
      add(ConnectionChanged(
          result ? ConnectionSuccess() : ConnectionFailure()));
    });
  }

  connectionInitialCheckedToState(
      ConnectionInitialChecked event, Emitter<NetworkState> emit) async {
    var hasConnection = await InternetConnectionChecker().hasConnection;
    emit(hasConnection ? ConnectionSuccess() : ConnectionFailure());
  }

  connectionChangedToState(
      ConnectionChanged event, Emitter<NetworkState> emit) async {
    emit(event.connection);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
