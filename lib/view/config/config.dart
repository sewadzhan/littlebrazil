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

  static getMonthString(int month) {
    switch (month) {
      case 1:
        return "января";
      case 2:
        return "февраля";
      case 3:
        return "марта";
      case 4:
        return "апреля";
      case 5:
        return "мая";
      case 6:
        return "июня";
      case 7:
        return "июля";
      case 8:
        return "августа";
      case 9:
        return "сентября";
      case 10:
        return "октября";
      case 11:
        return "ноября";
      case 12:
        return "декабря";
      default:
        throw RestaurantException("Illegal month number");
    }
  }

  //Get full available time hours for delivery
  static List<String> getFullTimeRanges(
      String openHourStr, String closeHourStr) {
    List<String> fullTimeRanges = [];

    int openHour = int.parse(openHourStr.split(':').first);
    int closeHour = int.parse(closeHourStr.split(':').first);

    int start = openHour + 2; //Start delivery in 2 hours after open
    while (start <= closeHour) {
      fullTimeRanges.add("$start:00");
      if (start != closeHour) {
        fullTimeRanges.add("$start:30");
      }
      start++;
    }

    return fullTimeRanges;
  }

  //Get today's available time hours for delivery
  static List<String> getTodayTimeRanges(String closeHourStr) {
    List<String> fullTimeRanges = ["Как можно скорее"];

    int closeHour = int.parse(closeHourStr.split(':').first);

    int start = DateTime.now().hour + 2;
    while (start <= closeHour) {
      fullTimeRanges.add("$start:00");
      if (start != closeHour) {
        fullTimeRanges.add("$start:30");
      }
      start++;
    }

    return fullTimeRanges;
  }
}
