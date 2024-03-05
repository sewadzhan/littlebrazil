import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/data/models/delivery_zone.dart';
import 'package:littlebrazil/data/repositories/firestore_repository.dart';
part 'delivery_zones_state.dart';

//Cubit for working with restaurant's delivery zones
class DeliveryZonesCubit extends Cubit<DeliveryZonesState> {
  final FirestoreRepository firestoreRepository;
  DeliveryZonesCubit(this.firestoreRepository)
      : super(DeliveryZonesLoadingState()) {
    getDeliveryZones();
  }
  void getDeliveryZones() async {
    try {
      final List<DeliveryZone> deliveryZones =
          await firestoreRepository.getDeliveryZones();
      emit(DeliveryZonesLoadedState(deliveryZones: deliveryZones));
    } catch (e) {
      print(e);
      emit(DeliveryZonesErrorState());
    }
  }
}
