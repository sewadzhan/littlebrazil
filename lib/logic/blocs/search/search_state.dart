part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

//Initial state of search page
class SearchInitial extends SearchState {}

//Loading state for search page
class SearchLoading extends SearchState {}

//Success results of search of products
class SearchSuccess extends SearchState {
  final List<Product> products;

  const SearchSuccess(this.products);

  @override
  List<Object> get props => [products];
}

//Failed results of product search
class SearchFailed extends SearchState {
  final String message;

  const SearchFailed(this.message);

  @override
  List<Object> get props => [message];
}
