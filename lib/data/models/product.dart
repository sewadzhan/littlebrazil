import 'package:littlebrazil/data/models/base_product.dart';
import 'package:littlebrazil/data/models/group_modifier.dart';

enum ProductTags { hit, discount, latest, none }

//Model for restaurant's products
class Product extends BaseProduct {
  final String description;
  final ProductTags tag;
  //final List<ProductFeature> features;
  final int order;
  final String gift;
  final List<GroupModifier> groupModifiers;

  const Product({
    required super.categoryID,
    required super.title,
    required super.price,
    required super.rmsID,
    required super.categoryTitle,
    required super.imageUrls,
    required this.description,
    this.tag = ProductTags.none,
    this.order = 9999,
    this.gift = '',
    this.groupModifiers = const [],
    //required this.features,
  });

  @override
  List<Object> get props => [imageUrls, title, price, categoryID];
}
