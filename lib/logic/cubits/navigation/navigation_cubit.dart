import 'package:flutter_bloc/flutter_bloc.dart';

//Cubit for navigation in Main Screen
class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);

  void setIndex(int index) async {
    emit(index);
  }
}
