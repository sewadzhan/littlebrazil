import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/data/models/faq_model.dart';
import 'package:littlebrazil/data/repositories/firestore_repository.dart';

part 'faq_event.dart';
part 'faq_state.dart';

//Bloc for FAQ Screen
class FAQBloc extends Bloc<FAQEvent, FAQState> {
  final FirestoreRepository firestoreRepository;

  FAQBloc(this.firestoreRepository) : super(FAQInitial()) {
    on<LoadFAQs>(loadFAQs);
    add(const LoadFAQs());
  }

  //Load FAQs
  loadFAQs(LoadFAQs event, Emitter<FAQState> emit) async {
    if (state is FAQInitial) {
      // try {
      emit(FAQLoading());

      List<FAQModel> orders = await firestoreRepository.getFAQs();

      emit(FAQLoaded(orders));
      // } catch (e) {
      //   emit(const FAQErrorState("Произошла непредвидимая ошибка"));
      // }
    }
  }
}
