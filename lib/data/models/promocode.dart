import 'dart:convert';

import 'package:equatable/equatable.dart';

//Types of promocode (percent descount or fixed value discount)
enum PromocodeType { percent, value }

//Promocode model
class Promocode extends Equatable {
  final PromocodeType type;
  final String code;
  final String discountID;
  final double value;
  final bool isActive;
  final bool canBeUsedOnlyOnce;
  final String startTimeLimit;
  final String finishTimeLimit;
  final List<String> iikoCategoryLimits;

  const Promocode(
      {required this.type,
      required this.code,
      required this.discountID,
      required this.value,
      required this.isActive,
      this.canBeUsedOnlyOnce = false,
      this.startTimeLimit = "",
      this.finishTimeLimit = "",
      this.iikoCategoryLimits = const []});

  @override
  List<Object> get props =>
      [type, code, discountID, value, canBeUsedOnlyOnce, iikoCategoryLimits];

  factory Promocode.fromMap(Map<String, dynamic> map) {
    PromocodeType type;

    switch (map['type']) {
      case "percent":
        type = PromocodeType.percent;
        break;
      default:
        type = PromocodeType.value;
    }
    return Promocode(
        type: type,
        code: map['code'] ?? '',
        discountID: map['discountID'] ?? '',
        value: map['value']?.toDouble() ?? 0.0,
        isActive: map['isActive'],
        canBeUsedOnlyOnce: map['canBeUsedOnlyOnce'] ?? false,
        startTimeLimit:
            map['hourlyLimit'] == null ? "" : map['hourlyLimit']['start'],
        finishTimeLimit:
            map['hourlyLimit'] == null ? "" : map['hourlyLimit']['finish'],
        iikoCategoryLimits: map['iikoCategoryLimits'] == null
            ? []
            : List<String>.from(map['iikoCategoryLimits']));
  }

  factory Promocode.fromJson(String source) =>
      Promocode.fromMap(json.decode(source));
}
