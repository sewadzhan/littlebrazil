import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:littlebrazil/logic/blocs/cart/cart_bloc.dart';
import 'package:littlebrazil/logic/blocs/network/network_bloc.dart';
import 'package:littlebrazil/logic/cubits/auth/logout_cubit.dart';
import 'package:littlebrazil/logic/cubits/localization/localization_cubit.dart';
import 'package:littlebrazil/logic/cubits/navigation/navigation_cubit.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:littlebrazil/view/screens/contacts_screen.dart';
import 'package:littlebrazil/view/screens/home_screen.dart';
import 'package:littlebrazil/view/screens/profile_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context
        .read<NetworkBloc>()
        .add(ConnectionInitialChecked()); //Check initial connection status
    final appLocalization = AppLocalizations.of(context)!;

    return MultiBlocListener(
      listeners: [
        BlocListener<NetworkBloc, NetworkState>(
          listener: (context, state) {
            if (state is ConnectionFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(Constants.noWifiSnackBar(context));
            } else if (state is ConnectionSuccess) {
              ScaffoldMessenger.of(context).clearSnackBars();
            }
          },
        ),
      ],
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, navigationState) {
          return Scaffold(
            body: IndexedStack(
              index: navigationState,
              children: const [
                HomeScreen(),
                ContactsScreen(),
                Placeholder(),
                Placeholder(),
                ProfileScreen(),
              ],
            ),
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: Constants.lightGrayColor, width: 1))),
              child: BlocConsumer<AuthCubit, User?>(
                listener: (context, state) async {
                  if (state == null) {
                    if (context.mounted) {
                      context.read<AuthCubit>().signOut();
                      context.read<NavigationCubit>().setIndex(0);
                      Navigator.of(context).pushNamed('/auth',
                          arguments: await context
                              .read<LocalizationCubit>()
                              .getFirstLaunchData());
                    }
                  }
                },
                builder: (context, authState) {
                  return BottomNavigationBar(
                    elevation: 0,
                    currentIndex: navigationState,
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Constants.backgroundColor,
                    onTap: (index) {
                      var isAuthenticated = authState != null;

                      //If tapped profile navigation bar or QR item it checks the authentication status
                      if ((index == 2 && !isAuthenticated) ||
                          (index == 4 && !isAuthenticated)) {
                        Navigator.pushNamed(context, '/auth');
                        return;
                      } else if (index == 2) {
                        Navigator.of(context).pushNamed('/qr');
                      } else if (index == 3) {
                        Navigator.of(context).pushNamed('/cart');
                      } else {
                        context.read<NavigationCubit>().setIndex(index);
                      }
                    },
                    items: [
                      BottomNavigationBarItem(
                          icon: SizedBox(
                            width: Constants.defaultPadding * 1.75,
                            child: SvgPicture.asset('assets/icons/home.svg',
                                colorFilter: navigationState == 0
                                    ? const ColorFilter.mode(
                                        Constants.secondPrimaryColor,
                                        BlendMode.srcIn)
                                    : null),
                          ),
                          label: appLocalization.homepage),
                      BottomNavigationBarItem(
                          icon: SizedBox(
                            width: Constants.defaultPadding * 1.75,
                            child: SvgPicture.asset('assets/icons/info.svg',
                                colorFilter: navigationState == 1
                                    ? const ColorFilter.mode(
                                        Constants.secondPrimaryColor,
                                        BlendMode.srcIn)
                                    : null),
                          ),
                          label: appLocalization.contacts),
                      BottomNavigationBarItem(
                          icon: Container(
                            width: 75,
                            height: 40,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: const BoxDecoration(
                                color: Constants.primaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: SizedBox(
                              child: SvgPicture.asset('assets/icons/qr.svg',
                                  colorFilter: const ColorFilter.mode(
                                      Colors.white, BlendMode.srcIn)),
                            ),
                          ),
                          label: "QR оплата"),
                      BottomNavigationBarItem(
                          icon: Stack(
                            children: [
                              SizedBox(
                                width: Constants.defaultPadding * 1.75,
                                child: SvgPicture.asset('assets/icons/cart.svg',
                                    colorFilter: navigationState == 3
                                        ? const ColorFilter.mode(
                                            Constants.secondPrimaryColor,
                                            BlendMode.srcIn)
                                        : null),
                              ),
                              BlocBuilder<CartBloc, CartState>(
                                builder: (context, cartState) {
                                  if (cartState is CartLoaded &&
                                      cartState.cart.items.isNotEmpty) {
                                    return Positioned(
                                        left: 18,
                                        top: 4,
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                              color: Constants.purpleColor,
                                              shape: BoxShape.circle),
                                        ));
                                  }
                                  return const SizedBox.shrink();
                                },
                              )
                            ],
                          ),
                          label: appLocalization.cart),
                      BottomNavigationBarItem(
                          icon: SizedBox(
                            width: Constants.defaultPadding * 1.75,
                            child: SvgPicture.asset('assets/icons/user.svg',
                                colorFilter: navigationState == 4
                                    ? const ColorFilter.mode(
                                        Constants.secondPrimaryColor,
                                        BlendMode.srcIn)
                                    : null),
                          ),
                          label: appLocalization.profile),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
