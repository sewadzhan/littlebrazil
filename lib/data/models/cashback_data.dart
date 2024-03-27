import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:littlebrazil/data/models/cashback_gradation.dart';

enum CashbackAction { deposit, withdraw }

class CashbackData extends Equatable {
  final List<CashbackGradation> gradations;
  final bool isEnabled;
  final CashbackAction cashbackAction;
  final bool isWelcomeBonusEnabled;
  final int welcomeBonus;

  const CashbackData({
    required this.gradations,
    required this.isEnabled,
    required this.cashbackAction,
    required this.isWelcomeBonusEnabled,
    required this.welcomeBonus,
  });

  factory CashbackData.fromMap(Map<String, dynamic> map) {
    List<CashbackGradation> gradations =
        List<Map<String, dynamic>>.from(map['gradations'])
            .map((e) => CashbackGradation(
                bound: e['bound'] ?? 0, percent: e['percent'] ?? 0))
            .toList();

    return CashbackData(
        gradations: gradations
          ..sort((CashbackGradation a, CashbackGradation b) =>
              a.bound.compareTo(b.bound)),
        isEnabled: map['isEnabled'] ?? false,
        cashbackAction: CashbackAction.deposit,
        isWelcomeBonusEnabled: map['isWelcomeBonusEnabled'] ?? false,
        welcomeBonus: map['welcomeBonus'] ?? 0);
  }

  factory CashbackData.fromJson(String source) =>
      CashbackData.fromMap(json.decode(source));

  CashbackData copyWith(
      {List<CashbackGradation>? gradations,
      bool? isEnabled,
      CashbackAction? cashbackAction,
      bool? isWelcomeBonusEnabled,
      int? welcomeBonus}) {
    return CashbackData(
      gradations: gradations ?? this.gradations,
      isEnabled: isEnabled ?? this.isEnabled,
      cashbackAction: cashbackAction ?? this.cashbackAction,
      isWelcomeBonusEnabled:
          isWelcomeBonusEnabled ?? this.isWelcomeBonusEnabled,
      welcomeBonus: welcomeBonus ?? this.welcomeBonus,
    );
  }

  @override
  List<Object> get props => [
        gradations,
        isEnabled,
        cashbackAction,
        isWelcomeBonusEnabled,
        welcomeBonus
      ];
}
