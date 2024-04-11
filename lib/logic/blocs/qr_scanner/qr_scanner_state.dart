part of 'qr_scanner_bloc.dart';

abstract class QRScannerState extends Equatable {
  const QRScannerState();

  @override
  List<Object> get props => [];
}

class QRScannerInitial extends QRScannerState {
  const QRScannerInitial();
}

//Success scan
class QRScannerSuccessScan extends QRScannerState {
  final Order order;

  const QRScannerSuccessScan(this.order);

  @override
  List<Object> get props => [order];
}

//Failed results
class QRScannerError extends QRScannerState {
  final String message;

  const QRScannerError(this.message);

  @override
  List<Object> get props => [message];
}
