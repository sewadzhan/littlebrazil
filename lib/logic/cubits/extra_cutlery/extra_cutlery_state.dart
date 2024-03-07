part of 'extra_cutlery_cubit.dart';

abstract class ExtraCutleryState extends Equatable {
  const ExtraCutleryState();

  @override
  List<Object?> get props => [];
}

class ExtraCutleryNotInitState extends ExtraCutleryState {}

class ExtraCutleryLoadedState extends ExtraCutleryState {
  final bool showPanel;
  final Product cutleryProduct;
  const ExtraCutleryLoadedState(
      {required this.showPanel, required this.cutleryProduct});

  @override
  List<Object?> get props => [showPanel, cutleryProduct];
}
