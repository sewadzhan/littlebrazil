part of 'qr_scanner_bloc.dart';

abstract class QRScannerEvent extends Equatable {
  const QRScannerEvent();

  @override
  List<Object> get props => [];
}

class QRScannerDataScanned extends QRScannerEvent {
  final String data;

  const QRScannerDataScanned(this.data);

  @override
  List<Object> get props => [data];
}
