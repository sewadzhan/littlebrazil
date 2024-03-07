import 'dart:convert';

import 'package:equatable/equatable.dart';

enum CashbackAction { deposit, withdraw, none }

class CashbackData extends Equatable {
  final int percent;
  final bool isEnabled;
  final CashbackAction cashbackAction;

  const CashbackData(this.percent, this.isEnabled, this.cashbackAction);

  factory CashbackData.fromMap(Map<String, dynamic> map) {
    return CashbackData(map['percent']?.toInt() ?? 0, map['isEnabled'] ?? false,
        CashbackAction.none);
  }

  factory CashbackData.fromJson(String source) =>
      CashbackData.fromMap(json.decode(source));

  CashbackData copyWith({
    int? percent,
    bool? isEnabled,
    CashbackAction? cashbackAction,
  }) {
    return CashbackData(
      percent ?? this.percent,
      isEnabled ?? this.isEnabled,
      cashbackAction ?? this.cashbackAction,
    );
  }

  @override
  List<Object> get props => [percent, isEnabled, cashbackAction];
}
