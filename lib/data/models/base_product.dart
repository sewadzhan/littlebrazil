import 'package:equatable/equatable.dart';

//Base of all products in menu
abstract class BaseProduct extends Equatable {
  final String categoryID;
  final String title;
  final List<String> imageUrls;
  final String rmsID;
  final int price;
  final String categoryTitle;

  const BaseProduct(
      {required this.categoryID,
      required this.title,
      required this.imageUrls,
      required this.rmsID,
      required this.price,
      required this.categoryTitle});

  @override
  List<Object> get props =>
      [categoryID, title, imageUrls, rmsID, price, categoryTitle];
}
