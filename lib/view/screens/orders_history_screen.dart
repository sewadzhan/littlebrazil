import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:littlebrazil/logic/blocs/order_history/order_history_bloc.dart';
import 'package:littlebrazil/logic/cubits/auth/logout_cubit.dart';
import 'package:littlebrazil/view/components/list_tiles/order_history_list_tile.dart';
import 'package:littlebrazil/view/components/sliver_body.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrdersHistoryScreen extends StatelessWidget {
  const OrdersHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final phoneNumber = context.read<AuthCubit>().state!.phoneNumber!;
    context.read<OrderHistoryBloc>().add(LoadOrderHistory(phoneNumber));
    return SliverBody(
      title: appLocalization.orderHistory,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: BlocConsumer<OrderHistoryBloc, OrderHistoryState>(
          listener: (context, state) {
            if (state is OrderHistoryErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                  Constants.errorSnackBar(context, state.message,
                      duration: const Duration(milliseconds: 1600)));
            }
          },
          builder: (context, state) {
            if (state is OrderHistoryLoaded) {
              if (state.orders.isEmpty) {
                return //Empty cart
                    SizedBox(
                  width: size.width,
                  height: size.height * 0.8,
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Positioned(
                          top: 0,
                          left: 00,
                          child: SvgPicture.asset(
                            'assets/decorations/order-history-top-left.svg',
                            width: 210,
                          )),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: SvgPicture.asset(
                            'assets/decorations/order-history-bottom-right.svg',
                            width: 450,
                          )),
                      Padding(
                        padding: EdgeInsets.only(
                            left: Constants.defaultPadding,
                            right: Constants.defaultPadding,
                            bottom: Constants.defaultPadding * 5),
                        child: Text(
                          appLocalization.itSeemsYouHavenTTriedOurDeliveryYet,
                          style: Constants.textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Padding(
                padding: EdgeInsets.only(
                  left: Constants.defaultPadding,
                  right: Constants.defaultPadding,
                  bottom: Constants.defaultPadding,
                ),
                child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: state.orders.length,
                    itemBuilder: (context, index) =>
                        OrderHistoryListTile(order: state.orders[index])),
              );
            }
            return Padding(
              padding: EdgeInsets.all(Constants.defaultPadding),
              child: const Center(
                child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      color: Constants.secondPrimaryColor,
                      strokeWidth: 2.5,
                    )),
              ),
            );
          },
        ),
      ),
    );
  }
}
