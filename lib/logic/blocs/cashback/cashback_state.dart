part of 'cashback_bloc.dart';

abstract class CashbackState extends Equatable {
  const CashbackState();

  @override
  List<Object> get props => [];
}

class CashbackInitial extends CashbackState {}

class CashbackLoading extends CashbackState {}

class CashbackLoaded extends CashbackState {
  final CashbackData cashbackData;

  const CashbackLoaded(this.cashbackData);

  //Get Cashback sum from final sum
  int getCashbackFromSum(int finalSum) {
    int cashback = 0;
    for (CashbackGradation gradation in cashbackData.gradations) {
      if (finalSum >= gradation.bound) {
        cashback = ((finalSum.toDouble() / 100) * gradation.percent).ceil();
      } else {
        break;
      }
    }

    return cashback;
  }

  @override
  List<Object> get props => [cashbackData];
}
