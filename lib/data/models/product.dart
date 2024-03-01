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
    required categoryID,
    required title,
    required price,
    required rmsID,
    required categoryTitle,
    required this.description,
    //required this.features,
    required imageUrls,
    this.tag = ProductTags.none,
    this.order = 9999,
    this.gift = '',
    this.groupModifiers = const [],
  }) : super(
            categoryID: categoryID,
            title: title,
            imageUrls: imageUrls,
            rmsID: rmsID,
            price: price,
            categoryTitle: categoryTitle);

  @override
  List<Object> get props => [imageUrls, title, price, categoryID];
}
