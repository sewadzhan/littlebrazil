import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:littlebrazil/logic/blocs/current_user/current_user_bloc.dart';
import 'package:littlebrazil/view/config/constants.dart';

class HomeScreenAppBar extends StatelessWidget {
  const HomeScreenAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Constants.backgroundColor,
      scrolledUnderElevation: 0,
      pinned: true,
      elevation: 0,
      centerTitle: true,
      title: SizedBox(
          width: 100, child: SvgPicture.asset('assets/logo/logo-dark.svg')),
      leadingWidth: 65 + Constants.defaultPadding,
      leading: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<CurrentUserBloc, CurrentUserState>(
            builder: (context, state) {
              if (state is CurrentUserRetrieveSuccessful) {
                return Container(
                  constraints: const BoxConstraints(
                    minWidth: 65,
                  ),
                  margin: EdgeInsets.only(left: Constants.defaultPadding),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: const BoxDecoration(
                      color: Constants.lightGreenColor,
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  child: Text(
                    "${state.user.cashback} Б",
                    textAlign: TextAlign.center,
                    style: Constants.headlineTextTheme.headlineSmall!.copyWith(
                      color: Constants.primaryColor,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      // actions: [
      //   TextButton(
      //     style: TextButton.styleFrom(
      //       shape: const CircleBorder(),
      //     ),
      //     onPressed: () {
      //       // Navigator.pushNamed(context, '/checkout');
      //     },
      //     child: SizedBox(
      //       width: 30,
      //       child: Stack(
      //         children: [
      //           Positioned(
      //             child: SvgPicture.asset(
      //               'assets/icons/shopping-bag.svg',
      //               colorFilter: const ColorFilter.mode(
      //                   Constants.darkGrayColor, BlendMode.srcIn),
      //             ),
      //           ),
      //           Positioned(
      //               left: 20,
      //               top: 18,
      //               child: Container(
      //                 width: 10,
      //                 height: 10,
      //                 decoration: const BoxDecoration(
      //                     color: Constants.purpleColor, shape: BoxShape.circle),
      //               ))
      //         ],
      //       ),
      //     ),
      //   ),
      // ],
    );
  }
}
