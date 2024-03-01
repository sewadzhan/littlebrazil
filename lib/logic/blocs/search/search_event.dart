part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

//Event for searching products in Search page
class SearchProducts extends SearchEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object> get props => [query];
}
