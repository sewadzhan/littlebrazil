import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:littlebrazil/data/models/cashback_gradation.dart';

enum CashbackAction { deposit, withdraw }

class CashbackData extends Equatable {
  final List<CashbackGradation> gradations;
  final bool isEnabled;
  final CashbackAction cashbackAction;

  const CashbackData(this.gradations, this.isEnabled, this.cashbackAction);

  factory CashbackData.fromMap(Map<String, dynamic> map) {
    List<CashbackGradation> gradations =
        List<Map<String, dynamic>>.from(map['gradations'])
            .map((e) => CashbackGradation(
                bound: e['bound'] ?? 0, percent: e['percent'] ?? 0))
            .toList();

    return CashbackData(
        gradations
          ..sort((CashbackGradation a, CashbackGradation b) =>
              a.bound.compareTo(b.bound)),
        map['isEnabled'] ?? false,
        CashbackAction.deposit);
  }

  factory CashbackData.fromJson(String source) =>
      CashbackData.fromMap(json.decode(source));

  CashbackData copyWith({
    List<CashbackGradation>? gradations,
    bool? isEnabled,
    CashbackAction? cashbackAction,
  }) {
    return CashbackData(
      gradations ?? this.gradations,
      isEnabled ?? this.isEnabled,
      cashbackAction ?? this.cashbackAction,
    );
  }

  @override
  List<Object> get props => [gradations, isEnabled, cashbackAction];
}
