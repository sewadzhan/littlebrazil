import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/data/models/about_company_model.dart';
import 'package:littlebrazil/data/repositories/firestore_repository.dart';

part 'about_company_state.dart';

//Cubit for About Company Screen
class AboutCompanyCubit extends Cubit<AboutCompanyState> {
  final FirestoreRepository firestoreRepository;

  AboutCompanyCubit(this.firestoreRepository)
      : super(const AboutCompanyLoadingState()) {
    getAboutCompany();
  }
  void getAboutCompany() async {
    try {
      final AboutCompanyModel aboutCompanyModel =
          await firestoreRepository.getAboutCompanyData();
      emit(AboutCompanyLoadedState(aboutCompanyModel: aboutCompanyModel));
    } catch (e) {
      emit(const AboutCompanyErrorState());
    }
  }
}
