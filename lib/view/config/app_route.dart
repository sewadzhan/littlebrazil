import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:littlebrazil/data/models/product.dart';
import 'package:littlebrazil/data/providers/firestore_provider.dart';
import 'package:littlebrazil/data/repositories/firestore_repository.dart';
import 'package:littlebrazil/logic/blocs/cart/cart_bloc.dart';
import 'package:littlebrazil/logic/blocs/current_user/current_user_bloc.dart';
import 'package:littlebrazil/logic/blocs/promocode/promocode_bloc.dart';
import 'package:littlebrazil/logic/blocs/search/search_bloc.dart';
import 'package:littlebrazil/logic/cubits/bottom_sheet/bottom_sheet_cubit.dart';
import 'package:littlebrazil/logic/cubits/contacts/contacts_cubit.dart';
import 'package:littlebrazil/logic/cubits/menu/menu_cubit.dart';
import 'package:littlebrazil/logic/cubits/navigation/navigation_cubit.dart';
import 'package:littlebrazil/logic/cubits/update_app/update_app_cubit.dart';
import 'package:littlebrazil/view/screens/cart_screen.dart';
import 'package:littlebrazil/view/screens/main_screen.dart';
import 'package:littlebrazil/view/screens/product_details_screen.dart';
import 'package:littlebrazil/view/screens/qr_scanner.dart';
import 'package:littlebrazil/view/screens/search_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static final FirestoreRepository firestoreRepository =
      FirestoreRepository(FirestoreProvider(FirebaseFirestore.instance));

  final NavigationCubit navigationCubit = NavigationCubit();
  static final MenuCubit menuCubit = MenuCubit(firestoreRepository)..getMenu();
  static final BottomSheetCubit bottomSheetCubit = BottomSheetCubit();
  static final UpdateAppCubit updateAppCubit = UpdateAppCubit(bottomSheetCubit);
  static final ContactsCubit contactsCubit =
      ContactsCubit(firestoreRepository, bottomSheetCubit, updateAppCubit);

  static final CurrentUserBloc currentUserBloc =
      CurrentUserBloc(firestoreRepository);
  static final CartBloc cartBloc = CartBloc()..add(LoadCart());

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return PageTransition(
          type: PageTransitionType.fade,
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: navigationCubit),
              BlocProvider.value(value: menuCubit),
              BlocProvider.value(value: cartBloc),
              BlocProvider.value(value: bottomSheetCubit),
              BlocProvider.value(value: contactsCubit),
            ],
            child: const MainScreen(),
          ),
        );
      case "/qr":
        return PageTransition(
            type: PageTransitionType.bottomToTop,
            duration: const Duration(milliseconds: 200),
            child: const QRScannerScreen());
      case "/search":
        return PageTransition(
            type: PageTransitionType.bottomToTop,
            duration: const Duration(milliseconds: 200),
            child: MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => SearchBloc(menuCubit))
              ],
              child: const SearchScreen(),
            ));
      case "/cart":
        return PageTransition(
            type: PageTransitionType.rightToLeft,
            duration: const Duration(milliseconds: 200),
            child: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: menuCubit),
                BlocProvider.value(value: cartBloc),
                BlocProvider(
                    create: (context) => PromocodeBloc(
                        firestoreRepository, cartBloc, currentUserBloc)
                      ..add(LoadPromocodes()))
              ],
              child: const CartScreen(),
            ));
      case "/productDetails":
        return PageTransition(
            type: PageTransitionType.fade,
            child: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: cartBloc),
              ],
              child:
                  ProductDetailsScreen(product: settings.arguments as Product),
            ));
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
        builder: (_) => const Scaffold(body: Center(child: Text("Error!"))),
        settings: const RouteSettings(name: "/error"));
  }

  void dispose() {}
}
