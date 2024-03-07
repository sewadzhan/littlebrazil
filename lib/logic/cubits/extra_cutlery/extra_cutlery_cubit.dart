import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/data/models/product.dart';
import 'package:littlebrazil/logic/blocs/cart/cart_bloc.dart';
part 'extra_cutlery_state.dart';

//Cubit for working with extra cutlery functionality (show or hide panel)
class ExtraCutleryCubit extends Cubit<ExtraCutleryState> {
  final CartBloc cartBloc;
  ExtraCutleryCubit(this.cartBloc) : super(ExtraCutleryNotInitState());
  //Initialize
  void init(Product extraCutleryProduct) async {
    emit(ExtraCutleryLoadedState(
        cutleryProduct: extraCutleryProduct, showPanel: false));
  }

  //Show the panel of extra cutlery in Checkout Screen
  void showPanel() async {
    if (state is ExtraCutleryLoadedState) {
      emit(ExtraCutleryLoadedState(
          cutleryProduct: (state as ExtraCutleryLoadedState).cutleryProduct,
          showPanel: true));
    }
  }

  //Hide the panel of extra cutlery in Checkout Screen
  void hidePanel() async {
    if (state is ExtraCutleryLoadedState) {
      emit(ExtraCutleryLoadedState(
          cutleryProduct: (state as ExtraCutleryLoadedState).cutleryProduct,
          showPanel: false));
    }
  }
}
