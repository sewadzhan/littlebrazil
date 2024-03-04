import 'package:flutter/material.dart';
import 'package:littlebrazil/data/models/product.dart';
import 'package:littlebrazil/view/config/constants.dart';

class Config {
  static String getTagTitle(ProductTags tag) {
    switch (tag) {
      case ProductTags.discount:
        return "СКИДКА";
      case ProductTags.hit:
        return "ХИТ";
      case ProductTags.latest:
        return "НОВИНКА";
      default:
        return "";
    }
  }

  static Color getTagColor(ProductTags tag) {
    switch (tag) {
      case ProductTags.discount:
        return Constants.thirdPrimaryColor;
      case ProductTags.hit:
        return Constants.purpleColor;
      case ProductTags.latest:
        return Constants.secondPrimaryColor;
      default:
        return Constants.primaryColor;
    }
  }

  static String tagToMap(ProductTags tag) {
    switch (tag) {
      case ProductTags.hit:
        return "hit";
      case ProductTags.discount:
        return "discount";
      case ProductTags.latest:
        return "latest";
      case ProductTags.none:
        return "none";
    }
  }
}
