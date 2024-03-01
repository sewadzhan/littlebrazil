import 'package:equatable/equatable.dart';
import 'package:littlebrazil/data/models/base_product.dart';

enum CategoryType { usual, none, extraSales, additional }

//Model for product's category
class Category extends Equatable {
  final CategoryType type;
  final String name;
  final List<BaseProduct> products;
  final String categoryID;

  const Category(
      {required this.type,
      required this.name,
      required this.products,
      required this.categoryID});

  @override
  List<Object?> get props => [name, products];
}
