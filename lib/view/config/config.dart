import 'package:flutter/material.dart';
import 'package:littlebrazil/data/models/checkout.dart';
import 'package:littlebrazil/data/models/product.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:littlebrazil/view/config/restaurant_exception.dart';

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

  static String paymentMethodToString(
      {bool isIOS = false, required PaymentMethod paymentMethod}) {
    switch (paymentMethod) {
      case PaymentMethod.applePay:
        return "Apple Pay";
      case PaymentMethod.googlePay:
        return "Google Pay";
      case PaymentMethod.cash:
        return "Наличными";
      case PaymentMethod.nonCash:
        return "Безналичными";
      case PaymentMethod.bankCard:
        return "Банковской картой";
      case PaymentMethod.kaspi:
        return "Kaspi Bank";
      default:
        return "";
    }
  }

  static PaymentMethod paymentMethodFromString(String paymentMethod) {
    switch (paymentMethod) {
      case "Apple Pay":
        return PaymentMethod.applePay;
      case "Google Pay":
        return PaymentMethod.googlePay;
      case "Наличными":
        return PaymentMethod.cash;
      case "Безналичными":
        return PaymentMethod.nonCash;
      case "Kaspi Bank":
        return PaymentMethod.kaspi;
      case "Банковской картой":
        return PaymentMethod.bankCard;
      case "Банковской картой / Apple Pay":
        return PaymentMethod.bankCard;
      case "Сохраненной картой":
        return PaymentMethod.savedBankCard;
      default:
        throw RestaurantException("Illegal payment method");
    }
  }

  static String orderTypeToString(OrderType orderType) {
    switch (orderType) {
      case OrderType.delivery:
        return "Доставка";
      case OrderType.pickup:
        return "Самовывоз";
    }
  }

  static OrderType orderTypeFromString(String orderType) {
    switch (orderType) {
      case "Доставка":
        return OrderType.delivery;
      case "Самовывоз":
        return OrderType.pickup;
      default:
        throw RestaurantException("Illegal order type");
    }
  }
}
