import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:littlebrazil/data/models/checkout.dart';
import 'package:littlebrazil/data/models/product.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:littlebrazil/view/config/restaurant_exception.dart';

class Config {
  static String getTagTitle(ProductTags tag, String languageCode) {
    switch (tag) {
      case ProductTags.discount:
        if (languageCode == "en") {
          return "DISCOUNT";
        } else if (languageCode == "kk") {
          return "ЖЕҢІЛДІК";
        }
        return "СКИДКА";
      case ProductTags.hit:
        if (languageCode == "en") {
          return "HIT";
        }
        return "ХИТ";
      case ProductTags.latest:
        if (languageCode == "en") {
          return "NEW";
        } else if (languageCode == "kk") {
          return "ЖАҢА";
        }
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

  static String paymentMethodToTitleString(
      {bool isIOS = false,
      required PaymentMethod paymentMethod,
      required String languageCode}) {
    switch (paymentMethod) {
      case PaymentMethod.applePay:
        return "Apple Pay";
      case PaymentMethod.googlePay:
        return "Google Pay";
      case PaymentMethod.cash:
        if (languageCode == "en") {
          return "Cash";
        } else if (languageCode == "kk") {
          return "Қолма-қол ақшамен";
        }
        return "Наличными";
      case PaymentMethod.nonCash:
        if (languageCode == "en") {
          return "Non cash";
        } else if (languageCode == "kk") {
          return "Қолма-қол ақшасыз";
        }
        return "Безналичными";
      case PaymentMethod.bankCard:
        if (languageCode == "en") {
          return "Bank card";
        } else if (languageCode == "kk") {
          return "Банк картасымен";
        }
        return "Банковской картой";
      case PaymentMethod.kaspi:
        return "Kaspi Bank";
      default:
        return "";
    }
  }

  static String paymentMethodToKeyString(
      {required PaymentMethod paymentMethod}) {
    switch (paymentMethod) {
      case PaymentMethod.applePay:
        return "applePay";
      case PaymentMethod.googlePay:
        return "googlePay";
      case PaymentMethod.cash:
        return "cash";
      case PaymentMethod.nonCash:
        return "nonCash";
      case PaymentMethod.bankCard:
        return "bankCard";
      case PaymentMethod.kaspi:
        return "kaspi";
      default:
        return "";
    }
  }

  static String getPaymentMethodIconPath(
      {bool isIOS = false, required PaymentMethod paymentMethod}) {
    switch (paymentMethod) {
      case PaymentMethod.bankCard:
        return "assets/icons/card.svg";
      case PaymentMethod.kaspi:
        return "assets/icons/kaspi.svg";
      default:
        return "assets/icons/card.svg";
    }
  }

  static String getPaymentMethodDescription(
      {bool isIOS = false,
      required PaymentMethod paymentMethod,
      required String languageCode}) {
    switch (paymentMethod) {
      case PaymentMethod.bankCard:
        return "";
      case PaymentMethod.kaspi:
        if (languageCode == "en") {
          return "in the banking application";
        } else if (languageCode == "kk") {
          return "банктік қосымшада";
        }
        return "в банковском приложении";
      default:
        return "";
    }
  }

  static PaymentMethod paymentMethodFromKeyString(String paymentMethod) {
    switch (paymentMethod) {
      case "applePay":
        return PaymentMethod.applePay;
      case "googlePay":
        return PaymentMethod.googlePay;
      case "cash":
        return PaymentMethod.cash;
      case "nonCash":
        return PaymentMethod.nonCash;
      case "kaspi":
        return PaymentMethod.kaspi;
      case "bankCard":
        return PaymentMethod.bankCard;
      case "savedBankCard":
        return PaymentMethod.savedBankCard;
      default:
        throw RestaurantException("Illegal payment method");
    }
  }

  static String orderTypeToTitleString(
      OrderType orderType, String languageCode) {
    switch (orderType) {
      case OrderType.delivery:
        if (languageCode == "en") {
          return "Delivery";
        } else if (languageCode == "kk") {
          return "Жеткізу";
        }
        return "Доставка";
      case OrderType.pickup:
        if (languageCode == "en") {
          return "Pickup";
        } else if (languageCode == "kk") {
          return "Алып кету";
        }
        return "Самовывоз";
    }
  }

  static String orderTypeToKeyString(OrderType orderType) {
    switch (orderType) {
      case OrderType.delivery:
        return "delivery";
      case OrderType.pickup:
        return "pickup";
    }
  }

  static OrderType orderTypeFromKeyString(String orderType) {
    switch (orderType) {
      case "delivery":
        return OrderType.delivery;
      case "pickup":
        return OrderType.pickup;
      default:
        throw RestaurantException("Illegal order type");
    }
  }

  static getMonthString(int month, String languageCode) {
    switch (month) {
      case 1:
        if (languageCode == "en") {
          return "January";
        } else if (languageCode == "kk") {
          return "қаңтар";
        }
        return "января";
      case 2:
        if (languageCode == "en") {
          return "February";
        } else if (languageCode == "kk") {
          return "ақпан";
        }
        return "февраля";
      case 3:
        if (languageCode == "en") {
          return "March";
        } else if (languageCode == "kk") {
          return "наурыз";
        }
        return "марта";
      case 4:
        if (languageCode == "en") {
          return "April";
        } else if (languageCode == "kk") {
          return "сәуір";
        }
        return "апреля";
      case 5:
        if (languageCode == "en") {
          return "May";
        } else if (languageCode == "kk") {
          return "мамыр";
        }
        return "мая";
      case 6:
        if (languageCode == "en") {
          return "June";
        } else if (languageCode == "kk") {
          return "маусым";
        }
        return "июня";
      case 7:
        if (languageCode == "en") {
          return "July";
        } else if (languageCode == "kk") {
          return "шілде";
        }
        return "июля";
      case 8:
        if (languageCode == "en") {
          return "August";
        } else if (languageCode == "kk") {
          return "тамыз";
        }
        return "августа";
      case 9:
        if (languageCode == "en") {
          return "September";
        } else if (languageCode == "kk") {
          return "қыркүйек";
        }
        return "сентября";
      case 10:
        if (languageCode == "en") {
          return "October";
        } else if (languageCode == "kk") {
          return "қазан";
        }
        return "октября";
      case 11:
        if (languageCode == "en") {
          return "November";
        } else if (languageCode == "kk") {
          return "";
        }
        return "қараша";
      case 12:
        if (languageCode == "en") {
          return "December";
        } else if (languageCode == "kk") {
          return "желтоқсан";
        }
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

  //Get today's available time hours for delivery and booking
  static List<String> getTodayTimeRanges(
      String openHourStr, String closeHourStr, String languageCode,
      {bool isBooking = false}) {
    List<String> fullTimeRanges = ["Как можно скорее"];
    if (isBooking) {
      fullTimeRanges = [];
    } else if (languageCode == "en") {
      fullTimeRanges = ["As soon as possible"];
    } else if (languageCode == "kk") {
      fullTimeRanges = ["Мүмкіндігінше тезірек"];
    }

    int closeHour = int.parse(closeHourStr.split(':').first);
    int openHour = int.parse(openHourStr.split(':').first);

    //Set another close time for booking
    if (isBooking) {
      closeHour -= 1;
    }

    var dateTime = DateTime.now();
    var dateFormat = DateFormat("dd.MM.yyyy HH:mm");
    var dateTimeOpen = dateFormat.parse(
        "${dateTime.day}.${dateTime.month}.${dateTime.year} $openHourStr");

    int start =
        dateTime.isAfter(dateTimeOpen) ? dateTime.hour + 2 : openHour + 2;
    while (start <= closeHour) {
      fullTimeRanges.add("$start:00");
      if (start != closeHour) {
        fullTimeRanges.add("$start:30");
      }
      start++;
    }

    return fullTimeRanges;
  }

  static List<String> getListOfDeliveryDays(
      {required String todayString, required String languageCode}) {
    DateTime dateTimeNow = DateTime.now();
    List<String> deliveryDays = [
      "$todayString, ${dateTimeNow.day} ${Config.getMonthString(dateTimeNow.month, languageCode)}"
    ];
    for (int i = 1; i <= 7; i++) {
      var tmp = dateTimeNow.add(Duration(days: i));
      deliveryDays.add(
        "${tmp.day} ${Config.getMonthString(tmp.month, languageCode)}",
      );
    }

    return deliveryDays;
  }
}
