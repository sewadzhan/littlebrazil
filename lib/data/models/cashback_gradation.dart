import 'package:equatable/equatable.dart';

class CashbackGradation extends Equatable {
  final int bound;
  final int percent;

  const CashbackGradation({required this.bound, required this.percent});

  @override
  List<Object?> get props => [bound, percent];
}
