import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:littlebrazil/logic/blocs/current_user/current_user_bloc.dart';
import 'package:littlebrazil/logic/blocs/network/network_bloc.dart';
import 'package:littlebrazil/logic/cubits/auth/logout_cubit.dart';
import 'package:littlebrazil/logic/cubits/navigation/navigation_cubit.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:littlebrazil/view/screens/contacts_screen.dart';
import 'package:littlebrazil/view/screens/home_screen.dart';
import 'package:littlebrazil/view/screens/profile_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var firebaseUser = context.read<AuthCubit>();
    if (firebaseUser.state?.phoneNumber != null) {
      var phoneNumber = firebaseUser.state!.phoneNumber!;
      if (phoneNumber.isNotEmpty) {
        //Retrieving all user data from Firestore
        context.read<CurrentUserBloc>().add(CurrentUserRetrieved(phoneNumber));
      }
    }

    //Check initial connection status
    context.read<NetworkBloc>().add(ConnectionInitialChecked());

    return MultiBlocListener(
      listeners: [
        BlocListener<CurrentUserBloc, CurrentUserState>(
          listener: (context, state) {
            if (state is CurrentUserRetrieveFailure) {
              firebaseUser.signOut();
              Navigator.of(context).pushNamed('/auth');
              context.read<NavigationCubit>().setIndex(0);
            }
          },
        ),
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
        builder: (context, state) {
          return Scaffold(
            body: IndexedStack(
              index: state,
              children: const [
                HomeScreen(),
                ContactsScreen(),
                Placeholder(),
                ProfileScreen(),
              ],
            ),
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: Constants.lightGrayColor, width: 1))),
              child: BottomNavigationBar(
                elevation: 0,
                currentIndex: state,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Constants.backgroundColor,
                onTap: (index) {
                  var isAuthenticated = context.read<AuthCubit>().state != null;

                  //If tapped profile navigation bar or QR item it checks the authentication status
                  if ((index == 2 && !isAuthenticated) ||
                      (index == 3 && !isAuthenticated)) {
                    Navigator.pushNamed(context, '/auth');
                    return;
                  }
                  if (index == 2) {
                    Navigator.of(context).pushNamed('/qr');
                  }
                  if (index == 4) {
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
                            colorFilter: state == 0
                                ? const ColorFilter.mode(
                                    Constants.secondPrimaryColor,
                                    BlendMode.srcIn)
                                : const ColorFilter.mode(
                                    Constants.darkGrayColor, BlendMode.srcIn)),
                      ),
                      label: "Главная"),
                  BottomNavigationBarItem(
                      icon: SizedBox(
                        width: Constants.defaultPadding * 1.75,
                        child: SvgPicture.asset('assets/icons/info.svg',
                            colorFilter: state == 1
                                ? const ColorFilter.mode(
                                    Constants.secondPrimaryColor,
                                    BlendMode.srcIn)
                                : const ColorFilter.mode(
                                    Constants.darkGrayColor, BlendMode.srcIn)),
                      ),
                      label: "Контакты"),
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
                      icon: SizedBox(
                        width: Constants.defaultPadding * 1.75,
                        child: SvgPicture.asset('assets/icons/user.svg',
                            colorFilter: state == 3
                                ? const ColorFilter.mode(
                                    Constants.secondPrimaryColor,
                                    BlendMode.srcIn)
                                : const ColorFilter.mode(
                                    Constants.darkGrayColor, BlendMode.srcIn)),
                      ),
                      label: "Профиль"),
                  BottomNavigationBarItem(
                      icon: SizedBox(
                        width: Constants.defaultPadding * 1.75,
                        child: SvgPicture.asset('assets/icons/cart.svg',
                            colorFilter: state == 4
                                ? const ColorFilter.mode(
                                    Constants.secondPrimaryColor,
                                    BlendMode.srcIn)
                                : const ColorFilter.mode(
                                    Constants.darkGrayColor, BlendMode.srcIn)),
                      ),
                      label: "Корзина")
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
