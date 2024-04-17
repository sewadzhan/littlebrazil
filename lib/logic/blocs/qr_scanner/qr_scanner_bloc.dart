import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/data/models/order.dart';

part 'qr_scanner_event.dart';
part 'qr_scanner_state.dart';

//Bloc for "QR Scanner" screen
class QRScannerBloc extends Bloc<QRScannerEvent, QRScannerState> {
  QRScannerBloc() : super(const QRScannerInitial()) {
    on<QRScannerDataScanned>(qrScannerDataScannedToState);
  }

  //QR Data Scanned
  qrScannerDataScannedToState(
      QRScannerDataScanned event, Emitter<QRScannerState> emit) async {
    try {
      // emit(const QRScannerSuccessScan());
      // emit(const QRScannerInitial()); //Reset Bloc
    } catch (e) {
      emit(const QRScannerError("Произошла непредвиденная ошибка"));
    }
  }
}
