import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/data/models/cart_item.dart';
import 'package:littlebrazil/data/models/checkout.dart';
import 'package:littlebrazil/data/models/order.dart';
import 'package:littlebrazil/data/models/product.dart';

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
      final test = Order(
          phoneNumber: 'sdf',
          fullAddress: 'г. Алматы, пр. Аль-Фараби, 140А',
          deliveryCost: 0,
          discount: 0,
          subtotal: 0,
          total: 66000,
          paymentMethod: PaymentMethod.kaspi,
          orderType: OrderType.delivery,
          cartItems: const [
            CartItemModel(
                product: Product(
                    categoryID: "",
                    title: "Рибай Стейк",
                    categoryTitle: "Стейки",
                    price: 3500,
                    rmsID: '',
                    description: '',
                    imageUrls: ['']),
                count: 3)
          ],
          id: 1234,
          dateTime: DateTime.now(),
          cashbackUsed: 0,
          comments: '');
      emit(QRScannerSuccessScan(test));
      emit(const QRScannerInitial()); //Reset Bloc
    } catch (e) {
      emit(const QRScannerError("Произошла непредвиденная ошибка"));
    }
  }
}
