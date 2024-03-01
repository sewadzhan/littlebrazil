part of 'menu_cubit.dart';

abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object?> get props => [];
}

class MenuLoadingState extends MenuState {}

class MenuLoadedState extends MenuState {
  final List<Category> categories;

  const MenuLoadedState({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class MenuErrorState extends MenuState {
  final String message;

  const MenuErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
