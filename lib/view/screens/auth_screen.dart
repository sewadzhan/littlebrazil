// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:littlebrazil/logic/blocs/network/network_bloc.dart';
// import 'package:littlebrazil/logic/blocs/phone_auth/phone_auth_bloc.dart';
// import 'package:littlebrazil/view/components/custom_elevated_button.dart';
// import 'package:littlebrazil/view/components/custom_text_input_field.dart';
// import 'package:littlebrazil/view/config/constants.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class AuthScreen extends StatefulWidget {
//   const AuthScreen({super.key});

//   @override
//   State<AuthScreen> createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen> {
//   void launchURL(Uri url) async => await canLaunchUrl(url)
//       ? await launchUrl(url)
//       : throw 'Could not launch $url';

//   TextEditingController nameController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();

//   @override
//   void dispose() {
//     nameController.dispose();
//     phoneController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     String policyUrl = "https://littlebrazil.kz/";

//     //Changing theme for small devices
//     // Constants.checkThemeForSmallDevices(
//     //     size.width, MediaQuery.of(context).devicePixelRatio);

//     //Check initial connection status
//     context.read<NetworkBloc>().add(ConnectionInitialChecked());

//     return BlocListener<NetworkBloc, NetworkState>(
//       listener: (context, state) {
//         if (state is ConnectionFailure) {
//           ScaffoldMessenger.of(context)
//               .showSnackBar(Constants.noWifiSnackBar(context));
//         } else if (state is ConnectionSuccess) {
//           ScaffoldMessenger.of(context).clearSnackBars();
//         }
//       },
//       child: Scaffold(
//         extendBodyBehindAppBar: true,
//         //resizeToAvoidBottomInset: false,
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           leading: TextButton(
//             style: TextButton.styleFrom(
//               shape: const CircleBorder(),
//             ),
//             child: const Icon(
//               Icons.close_rounded,
//               color: Constants.primaryColor,
//               size: 28,
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//         ),
//         body: SizedBox(
//           width: size.width,
//           height: size.height,
//           child: Stack(
//             alignment: AlignmentDirectional.topCenter,
//             children: [
//               Positioned(
//                   top: 0,
//                   left: 10,
//                   child: SvgPicture.asset('assets/decorations/topLeft.svg')),
//               Positioned(
//                   bottom: 0,
//                   right: 0,
//                   child:
//                       SvgPicture.asset('assets/decorations/bottomRight.svg')),
//               SizedBox(
//                 width: size.width > 500 ? 380 : size.width,
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: Constants.defaultPadding * 1.5),
//                   child: Column(
//                     children: [
//                       const Spacer(),
//                       Padding(
//                         padding:
//                             EdgeInsets.only(bottom: Constants.defaultPadding),
//                         child: SvgPicture.asset('assets/logo/textLogo.svg'),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(
//                             bottom: Constants.defaultPadding / 4),
//                         child: Text(
//                           "Укажите имя и телефон",
//                           style: Constants.textTheme.headlineSmall,
//                         ),
//                       ),
//                       Text(
//                         "Чтобы войти или зарегистрироваться",
//                         style: Constants.textTheme.headlineSmall,
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(
//                             top: Constants.defaultPadding,
//                             bottom: Constants.defaultPadding * 0.75),
//                         child: CustomTextInputField(
//                           controller: nameController,
//                           titleText: "Имя",
//                           hintText: "Марк",
//                           keyboardType: TextInputType.text,
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(
//                             bottom: Constants.defaultPadding * 0.75),
//                         child: CustomTextInputField(
//                             controller: phoneController,
//                             titleText: "Мобильный телефон",
//                             hintText: "8 707 454 54 54",
//                             keyboardType: const TextInputType.numberWithOptions(
//                                 signed: true, decimal: true)),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(
//                             top: Constants.defaultPadding * 0.75,
//                             bottom: Constants.defaultPadding * 0.5),
//                         child: Row(
//                           children: [
//                             // BlocBuilder<LoginCheckboxCubit, bool>(
//                             //   builder: (context, state) {
//                             //     return Checkbox(
//                             //         value: state,
//                             //         activeColor: Constants.primaryColor,
//                             //         onChanged: (bool? val) {
//                             //           context
//                             //               .read<LoginCheckboxCubit>()
//                             //               .changeValue();
//                             //         });
//                             //   },
//                             // ),
//                             Flexible(
//                               child: RichText(
//                                 text: TextSpan(
//                                     text:
//                                         "Я согласен на обработку персональных данных. ",
//                                     style: Constants.textTheme.headlineSmall,
//                                     children: [
//                                       TextSpan(
//                                         text: "Подробнее",
//                                         style: Constants
//                                             .textTheme.headlineSmall!
//                                             .copyWith(
//                                           decoration: TextDecoration.underline,
//                                         ),
//                                         recognizer: TapGestureRecognizer()
//                                           ..onTap = () async =>
//                                               launchURL(Uri.parse(policyUrl)),
//                                       )
//                                     ]),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       BlocConsumer<PhoneAuthBloc, PhoneAuthState>(
//                         listener: (context, state) {
//                           ScaffoldMessenger.of(context).clearSnackBars();
//                           if (state is PhoneAuthLoading) {
//                             // ScaffoldMessenger.of(context).showSnackBar(
//                             //     Constants.loadingSnackBar(context));
//                           } else if (state
//                               is PhoneAuthNumberVerificationFailure) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                                 Constants.errorSnackBar(context, state.message,
//                                     duration:
//                                         const Duration(milliseconds: 800)));
//                           } else if (state
//                               is PhoneAuthNumberVerificationSuccess) {
//                             Navigator.pushNamed(context, '/otp', arguments: [
//                               nameController.text,
//                               phoneController.text
//                             ]);
//                           }
//                         },
//                         builder: (context, phoneAuthState) {
//                           return CustomElevatedButton(
//                               text: "Войти",
//                               isEnabled: phoneAuthState
//                                   is! PhoneAuthLoading //&& loginCheckBoxState
//                               ,
//                               function: () {
//                                 if (nameController.text.isEmpty) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                       Constants.errorSnackBar(
//                                           context, "Заполните имя"));
//                                   return;
//                                 }
//                                 context.read<PhoneAuthBloc>().add(
//                                     PhoneAuthNumberVerified(
//                                         phoneNumber: phoneController.text));
//                               });
//                         },
//                       ),
//                       const Spacer(),
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
