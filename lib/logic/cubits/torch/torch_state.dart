part of 'torch_cubit.dart';

sealed class TorchState extends Equatable {
  const TorchState();

  @override
  List<Object> get props => [];
}

final class TorchInitial extends TorchState {}

final class TorchInactive extends TorchState {
  const TorchInactive();
}

final class TorchActive extends TorchState {
  final bool isEnabled;

  const TorchActive({required this.isEnabled});

  @override
  List<Object> get props => [isEnabled];
}

final class TorchError extends TorchState {
  final String message;

  const TorchError({required this.message});

  @override
  List<Object> get props => [message];
}
