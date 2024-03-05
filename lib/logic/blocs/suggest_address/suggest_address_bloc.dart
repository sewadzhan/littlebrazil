import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/data/repositories/yandex_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'suggest_address_event.dart';
part 'suggest_address_state.dart';

//Bloc for searching restaurant's products
class SuggestAddressBloc
    extends Bloc<SuggestAddressEvent, SuggestAddressState> {
  final YandexRepository yandexRepository;
  SuggestAddressBloc(this.yandexRepository) : super(SuggestAddressInitial()) {
    on<SuggestAddress>(suggestAddressToState,
        transformer: debounceSequential(const Duration(milliseconds: 700)));
  }

  //Query processing from search of products
  suggestAddressToState(
      SuggestAddress event, Emitter<SuggestAddressState> emit) async {
    try {
      //If query is empty => return initial state
      if (event.query.trim().isEmpty) {
        emit(SuggestAddressInitial());
        return;
      }

      emit(SuggestAddressLoading());
      await Future<void>.delayed(const Duration(milliseconds: 300));

      // try {
      List<String> result =
          await yandexRepository.getSuggestedAddresses(event.query);

      emit(SuggestAddressSuccess(result));
    } catch (e) {
      emit(SuggestAddressFailed(e.toString()));
    }
  }
}

EventTransformer<E> debounceSequential<E>(Duration duration) {
  return (events, mapper) {
    return sequential<E>().call(events.debounceTime(duration), mapper);
  };
}
