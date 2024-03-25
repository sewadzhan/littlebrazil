import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/logic/blocs/cashback/cashback_bloc.dart';
import 'package:littlebrazil/view/config/constants.dart';

//Loyal System info bottom sheet
class LoyalSystemBottomSheet extends StatelessWidget {
  const LoyalSystemBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        SafeArea(
            child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                    top: Constants.defaultPadding * 2,
                    left: Constants.defaultPadding,
                    right: Constants.defaultPadding,
                    bottom: Constants.defaultPadding * 0.25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: Constants.defaultPadding * 0.5),
                      child: Text("Система лояльности",
                          style: Constants.headlineTextTheme.displayMedium!
                              .copyWith(
                            color: Constants.primaryColor,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: Constants.defaultPadding * 0.25),
                      child: Text(
                        "Накапливайте баллы и получайте скидки!",
                        style: Constants.textTheme.bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: Constants.defaultPadding * 0.5),
                      child: Text(
                        "Как работает:\n• За каждый заказ вы получаете баллы\n• Чем больше сумма заказа, тем больше баллов вы получаете\n• Баллы можно использовать для оплаты будущих заказов",
                        style: Constants.textTheme.bodyMedium,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: Constants.defaultPadding * 0.25),
                      child: Text(
                        "Как использовать баллы:",
                        style: Constants.textTheme.bodyMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: Constants.defaultPadding * 0.5),
                      child: Text(
                        "• 1 балл = 1 ₸\n• Вы можете использовать баллы для оплаты до 100% стоимости заказа\n• Баллы не сгорают",
                        style: Constants.textTheme.bodyMedium,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: Constants.defaultPadding * 0.25),
                      child: Text(
                        "Градация начисления бонусов:",
                        style: Constants.textTheme.bodyMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    BlocBuilder<CashbackBloc, CashbackState>(
                      builder: (context, state) {
                        if (state is CashbackLoaded) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                                state.cashbackData.gradations.length,
                                (index) => Text(
                                      "• Свыше ${state.cashbackData.gradations[index].bound} ₸: ${state.cashbackData.gradations[index].percent}% от суммы заказа",
                                      style: Constants.textTheme.bodyMedium,
                                    )),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ))),
      ],
    );
  }
}
