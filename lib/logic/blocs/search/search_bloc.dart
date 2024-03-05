import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/data/models/category.dart';
import 'package:littlebrazil/data/models/product.dart';
import 'package:littlebrazil/logic/cubits/menu/menu_cubit.dart';
import 'package:rxdart/rxdart.dart';

part 'search_event.dart';
part 'search_state.dart';

//Bloc for searching restaurant's products
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MenuCubit menuCubit;

  EventTransformer<E> debounceSequential<E>(Duration duration) {
    return (events, mapper) {
      return sequential<E>().call(events.debounceTime(duration), mapper);
    };
  }

  SearchBloc(this.menuCubit) : super(SearchInitial()) {
    on<SearchProducts>(searchProductsToState,
        transformer: debounceSequential(const Duration(milliseconds: 200)));
  }

  //Query processing from search of products
  searchProductsToState(SearchProducts event, Emitter<SearchState> emit) async {
    if (menuCubit.state is MenuLoadedState) {
      //If query is empty => return initial state
      if (event.query.trim().isEmpty) {
        emit(SearchInitial());
        return;
      }

      emit(SearchLoading());
      await Future<void>.delayed(const Duration(milliseconds: 700));

      var categories = (menuCubit.state as MenuLoadedState).categories;
      List<Product> result = [];

      try {
        for (var category in categories) {
          if (category.type == CategoryType.usual) {
            for (var product in category.products) {
              if (product.title.toLowerCase().contains(event.query)) {
                result.add(product as Product);
              }
            }
          }
        }
        emit(SearchSuccess(result));
      } catch (e) {
        emit(SearchFailed(e.toString()));
      }
    }
  }
}
