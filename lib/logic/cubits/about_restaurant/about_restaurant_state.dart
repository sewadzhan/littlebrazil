part of 'about_restaurant_cubit.dart';

abstract class AboutRestaurantState extends Equatable {
  const AboutRestaurantState();

  @override
  List<Object?> get props => [];
}

class AboutRestaurantLoadingState extends AboutRestaurantState {}

class AboutRestaurantLoadedState extends AboutRestaurantState {
  final AboutRestaurantModel aboutRestaurantModel;

  const AboutRestaurantLoadedState({required this.aboutRestaurantModel});

  @override
  List<Object?> get props => [aboutRestaurantModel];
}

class AboutRestaurantErrorState extends AboutRestaurantState {}
