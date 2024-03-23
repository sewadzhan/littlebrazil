part of 'rate_app_cubit.dart';

abstract class RateAppState extends Equatable {
  const RateAppState();

  @override
  List<Object> get props => [];
}

class RateAppInitial extends RateAppState {}

class RateAppPopupShowed extends RateAppState {}
