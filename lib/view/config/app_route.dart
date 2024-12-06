import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littlebrazil/data/models/product.dart';
import 'package:littlebrazil/data/models/story_screen_argument.dart';
import 'package:littlebrazil/data/providers/auth_firebase_provider.dart';
import 'package:littlebrazil/data/providers/firestore_provider.dart';
import 'package:littlebrazil/data/providers/functions_provider.dart';
import 'package:littlebrazil/data/providers/yandex_provider.dart';
import 'package:littlebrazil/data/repositories/auth_repository.dart';
import 'package:littlebrazil/data/repositories/firestore_repository.dart';
import 'package:littlebrazil/data/repositories/functions_repository.dart';
import 'package:littlebrazil/data/repositories/yandex_repository.dart';
import 'package:littlebrazil/logic/blocs/add_address/add_address_bloc.dart';
import 'package:littlebrazil/logic/blocs/address/address_bloc.dart';
import 'package:littlebrazil/logic/blocs/cart/cart_bloc.dart';
import 'package:littlebrazil/logic/blocs/cashback/cashback_bloc.dart';
import 'package:littlebrazil/logic/blocs/checkout/checkout_bloc.dart';
import 'package:littlebrazil/logic/blocs/current_user/current_user_bloc.dart';
import 'package:littlebrazil/logic/blocs/edit_user/edit_user_bloc.dart';
import 'package:littlebrazil/logic/blocs/faq/faq_bloc.dart';
import 'package:littlebrazil/logic/blocs/geolocation/geolocation_bloc.dart';
import 'package:littlebrazil/logic/blocs/network/network_bloc.dart';
import 'package:littlebrazil/logic/blocs/order/order_bloc.dart';
import 'package:littlebrazil/logic/blocs/order_history/order_history_bloc.dart';
import 'package:littlebrazil/logic/blocs/phone_auth/phone_auth_bloc.dart';
import 'package:littlebrazil/logic/blocs/promocode/promocode_bloc.dart';
import 'package:littlebrazil/logic/blocs/qr_scanner/qr_scanner_bloc.dart';
import 'package:littlebrazil/logic/blocs/search/search_bloc.dart';
import 'package:littlebrazil/logic/blocs/suggest_address/suggest_address_bloc.dart';
import 'package:littlebrazil/logic/cubits/about_company/about_company_cubit.dart';
import 'package:littlebrazil/logic/cubits/about_restaurant/about_restaurant_cubit.dart';
import 'package:littlebrazil/logic/cubits/auth/logout_cubit.dart';
import 'package:littlebrazil/logic/cubits/booking/booking_cubit.dart';
import 'package:littlebrazil/logic/cubits/bottom_sheet/bottom_sheet_cubit.dart';
import 'package:littlebrazil/logic/cubits/contacts/contacts_cubit.dart';
import 'package:littlebrazil/logic/cubits/delivery_zones/delivery_zones_cubit.dart';
import 'package:littlebrazil/logic/cubits/menu/menu_cubit.dart';
import 'package:littlebrazil/logic/cubits/navigation/navigation_cubit.dart';
import 'package:littlebrazil/logic/cubits/otp_section/otp_section_cubit.dart';
import 'package:littlebrazil/logic/cubits/rate_app/rate_app_cubit.dart';
import 'package:littlebrazil/logic/cubits/stories/stories_cubit.dart';
import 'package:littlebrazil/view/screens/about_company_screen.dart';
import 'package:littlebrazil/view/screens/about_restaurant_screen.dart';
import 'package:littlebrazil/view/screens/add_address_screen.dart';
import 'package:littlebrazil/view/screens/auth_screen.dart';
import 'package:littlebrazil/view/screens/booking_screen.dart';
import 'package:littlebrazil/view/screens/cart_screen.dart';
import 'package:littlebrazil/view/screens/checkout_screen.dart';
import 'package:littlebrazil/view/screens/delete_account_screen.dart';
import 'package:littlebrazil/view/screens/faq_screen.dart';
import 'package:littlebrazil/view/screens/main_screen.dart';
import 'package:littlebrazil/view/screens/my_addresses_screen.dart';
import 'package:littlebrazil/view/screens/my_profile_screen.dart';
import 'package:littlebrazil/view/screens/order_details_screen.dart';
import 'package:littlebrazil/view/screens/orders_history_screen.dart';
import 'package:littlebrazil/view/screens/product_details_screen.dart';
import 'package:littlebrazil/view/screens/qr_scanner.dart';
import 'package:littlebrazil/view/screens/search_screen.dart';
import 'package:littlebrazil/view/screens/story_screen.dart';
import 'package:littlebrazil/view/screens/success_order_screen.dart';
import 'package:littlebrazil/view/screens/success_qr_scanned_screen.dart.dart';
import 'package:littlebrazil/view/screens/suggest_address_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/data/models/order.dart' as order;

class AppRouter {
  static final AuthRepository authRepository =
      AuthRepository(AuthFirebaseProvider(FirebaseAuth.instance));
  static final FirestoreRepository firestoreRepository =
      FirestoreRepository(FirestoreProvider(FirebaseFirestore.instance));
  static final FunctionsRepositoty functionsRepositoty =
      FunctionsRepositoty(const FunctionsProvider());

  static AuthCubit authCubit = AuthCubit(authRepository);
  static final MenuCubit menuCubit = MenuCubit(firestoreRepository)..getMenu();
  static final BottomSheetCubit bottomSheetCubit = BottomSheetCubit();
  // static final UpdateAppCubit updateAppCubit = UpdateAppCubit(bottomSheetCubit);
  static final ContactsCubit contactsCubit = ContactsCubit(
    firestoreRepository,
    bottomSheetCubit,
    // updateAppCubit,
  );
  static final DeliveryZonesCubit deliveryZonesCubit =
      DeliveryZonesCubit(firestoreRepository);
  static final NavigationCubit navigationCubit = NavigationCubit();

  static final AddressBloc addressBloc =
      AddressBloc(firestoreRepository, checkoutBloc);
  static final CashbackBloc cashbackBloc =
      CashbackBloc(firestoreRepository, currentUserBloc)
        ..add(LoadCashbackData());
  static final CurrentUserBloc currentUserBloc = CurrentUserBloc(
      firestoreRepository, addressBloc, authCubit, checkoutBloc);
  static final CartBloc cartBloc = CartBloc()..add(LoadCart());
  static final CheckoutBloc checkoutBloc =
      CheckoutBloc(deliveryZonesCubit, cartBloc);
  final OrderBloc orderBloc = OrderBloc(
      firestoreRepository: firestoreRepository,
      cartBloc: cartBloc,
      contactsCubit: contactsCubit,
      currentUserBloc: currentUserBloc,
      cashbackBloc: cashbackBloc,
      bottomSheetCubit: bottomSheetCubit);
  final NetworkBloc networkBloc = NetworkBloc();
  final PhoneAuthBloc phoneAuthBloc = PhoneAuthBloc(
      authRepository:
          AuthRepository(AuthFirebaseProvider(FirebaseAuth.instance)),
      firestoreRepository: firestoreRepository,
      functionsRepositoty: functionsRepositoty);

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return PageTransition(
          type: PageTransitionType.fade,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (context) => StoriesCubit(firestoreRepository)),
              BlocProvider.value(value: navigationCubit),
              BlocProvider.value(value: authCubit),
              BlocProvider.value(value: menuCubit),
              BlocProvider.value(value: cartBloc),
              BlocProvider.value(value: bottomSheetCubit),
              BlocProvider.value(value: contactsCubit),
              BlocProvider.value(value: networkBloc),
              BlocProvider.value(value: currentUserBloc),
              BlocProvider.value(value: cashbackBloc),
            ],
            child: const MainScreen(),
          ),
        );
      case "/auth":
        bool? isFirstLaunch = settings.arguments as bool?;
        return PageTransition(
            type: PageTransitionType.fade,
            child: MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: authCubit),
                  BlocProvider.value(value: phoneAuthBloc),
                  BlocProvider.value(value: currentUserBloc),
                  BlocProvider.value(value: cashbackBloc),
                  BlocProvider(create: (context) => OTPSectionCubit())
                ],
                child: AuthScreen(
                  isFirstLaunch: isFirstLaunch ?? false,
                )));
      case "/qr":
        return PageTransition(
            type: PageTransitionType.bottomToTop,
            duration: const Duration(milliseconds: 250),
            child: BlocProvider(
              create: (context) => QRScannerBloc(),
              child: const QRScannerScreen(),
            ));
      case "/successQRscanned":
        return CupertinoPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: orderBloc),
                    BlocProvider.value(value: cashbackBloc),
                    BlocProvider.value(value: contactsCubit),
                    BlocProvider.value(value: checkoutBloc),
                    BlocProvider.value(value: currentUserBloc),
                  ],
                  child: SuccessQRScannedScreen(
                    order: settings.arguments as order.Order,
                  ),
                ));
      case "/search":
        return CupertinoPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (context) => SearchBloc(menuCubit)),
                    BlocProvider.value(value: cartBloc),
                  ],
                  child: const SearchScreen(),
                ));
      case "/cart":
        return CupertinoPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (context) => PromocodeBloc(
                            firestoreRepository, cartBloc, currentUserBloc)
                          ..add(LoadPromocodes())),
                    BlocProvider.value(value: authCubit),
                    BlocProvider.value(value: menuCubit),
                    BlocProvider.value(value: cartBloc),
                    BlocProvider.value(value: contactsCubit),
                  ],
                  child: const CartScreen(),
                ));
      case "/productDetails":
        return CupertinoPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: cartBloc),
                  ],
                  child: ProductDetailsScreen(
                      product: settings.arguments as Product),
                ));
      case "/myAddresses":
        return CupertinoPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(
                      value: addressBloc,
                    ),
                    BlocProvider.value(value: authCubit),
                  ],
                  child: const MyAddressesScreen(),
                ));
      case "/addAddress":
        return CupertinoPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (_) => AddAddressBloc(deliveryZonesCubit)),
                    BlocProvider(
                        create: (_) =>
                            GeolocationBloc()..add(LoadGeolocation())),
                    BlocProvider.value(value: authCubit),
                    BlocProvider.value(value: addressBloc),
                    BlocProvider.value(value: deliveryZonesCubit),
                  ],
                  child: const AddAddressScreen(),
                ));
      case "/suggestAddress":
        return CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (_) => BlocProvider(
            create: (context) =>
                SuggestAddressBloc(YandexRepository(YandexProvider())),
            child: const SuggestAddressScreen(),
          ),
        );
      case "/checkout":
        return CupertinoPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: checkoutBloc),
                    BlocProvider.value(value: addressBloc),
                    BlocProvider.value(value: cartBloc),
                    BlocProvider.value(value: contactsCubit),
                    BlocProvider.value(value: orderBloc),
                    BlocProvider.value(value: deliveryZonesCubit),
                    BlocProvider.value(value: cashbackBloc),
                    BlocProvider.value(value: currentUserBloc),
                    BlocProvider.value(value: contactsCubit),
                  ],
                  child: const CheckoutScreen(),
                ));
      case "/userProfile":
        return CupertinoPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => EditUserBloc(firestoreRepository),
                    ),
                    BlocProvider.value(value: authCubit),
                    BlocProvider.value(value: currentUserBloc),
                    BlocProvider.value(value: contactsCubit),
                  ],
                  child: const MyProfileScreen(),
                ));
      case "/ordersHistory":
        return CupertinoPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) =>
                          OrderHistoryBloc(firestoreRepository),
                    ),
                    BlocProvider.value(value: authCubit),
                  ],
                  child: const OrdersHistoryScreen(),
                ));
      case "/successOrder":
        return PageTransition(
            type: PageTransitionType.bottomToTop,
            duration: const Duration(milliseconds: 250),
            child: BlocProvider(
              create: (context) => RateAppCubit(),
              child: SuccessOrderScreen(
                order: settings.arguments as order.Order,
              ),
            ));
      case "/orderDetails":
        return CupertinoPageRoute(
            builder: (_) =>
                OrderDetailsScreen(order: settings.arguments as order.Order));
      case "/aboutRestaurant":
        return CupertinoPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) =>
                      AboutRestaurantCubit(firestoreRepository),
                  child: const AboutRestaurantScreen(),
                ));
      case "/story":
        return PageTransition(
            type: PageTransitionType.fade,
            duration: const Duration(milliseconds: 250),
            child: StoryScreen(
                storyScreenArgument:
                    settings.arguments as StoryScreenArgument));
      case "/faq":
        return CupertinoPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => FAQBloc(firestoreRepository),
                  child: const FAQScreen(),
                ));
      case "/deleteAccount":
        return CupertinoPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(value: currentUserBloc),
                    BlocProvider.value(value: navigationCubit),
                    BlocProvider.value(value: authCubit),
                  ],
                  child: const DeleteAccountScreen(),
                ));
      case "/booking":
        return CupertinoPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider.value(
                      value: contactsCubit,
                    ),
                    BlocProvider(
                      create: (context) => BookingCubit(currentUserBloc),
                    ),
                  ],
                  child: const BookingScreen(),
                ),
            settings: const RouteSettings(name: "/booking"));
      case "/aboutCompany":
        return CupertinoPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => AboutCompanyCubit(firestoreRepository),
                  child: const AboutCompanyScreen(),
                ),
            settings: const RouteSettings(name: "/aboutCompany"));
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return CupertinoPageRoute(
        builder: (_) => const Scaffold(body: Center(child: Text("Error!"))),
        settings: const RouteSettings(name: "/error"));
  }

  void dispose() {}
}
