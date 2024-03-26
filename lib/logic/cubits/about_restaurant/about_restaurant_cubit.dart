import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/data/models/about_restaurant_model.dart';
import 'package:littlebrazil/data/repositories/firestore_repository.dart';

part 'about_restaurant_state.dart';

//Cubit for About Restaurant Screen
class AboutRestaurantCubit extends Cubit<AboutRestaurantState> {
  final FirestoreRepository firestoreRepository;

  AboutRestaurantCubit(this.firestoreRepository)
      : super(AboutRestaurantLoadingState()) {
    getAboutRestaurant();
  }
  void getAboutRestaurant() async {
    // try {
    final AboutRestaurantModel aboutRestaurantModel =
        await firestoreRepository.getAboutRestaurantData();
    emit(
        AboutRestaurantLoadedState(aboutRestaurantModel: aboutRestaurantModel));
    // } catch (e) {
    //   emit(AboutRestaurantErrorState());
    // }
  }
}
