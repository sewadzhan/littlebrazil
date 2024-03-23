import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:torch_light/torch_light.dart';

part 'torch_state.dart';

//Cubit for torch functionality
class TorchCubit extends Cubit<TorchState> {
  TorchCubit() : super(TorchInitial());

  void checkAvailability() async {
    if (state is TorchInitial) {
      try {
        final isTorchAvailable = await TorchLight.isTorchAvailable();
        if (isTorchAvailable) {
          emit(const TorchActive(isEnabled: false));
        } else {
          emit(const TorchInactive());
        }
      } on Exception catch (_) {}
    }
  }

  void toggleTorch() async {
    if (state is TorchActive) {
      try {
        if ((state as TorchActive).isEnabled) {
          await TorchLight.disableTorch();
        } else {
          await TorchLight.enableTorch();
        }
      } on EnableTorchExistentUserException catch (e) {
        emit(TorchError(message: "The camera is in use: ${e.message}"));
      } on EnableTorchNotAvailableException catch (e) {
        emit(TorchError(message: "Torch was not detected: ${e.message}"));
      } on EnableTorchException catch (e) {
        emit(TorchError(
            message: "Произошла непредвидимая ошибка: ${e.message} "));
      }
    }
  }
}
