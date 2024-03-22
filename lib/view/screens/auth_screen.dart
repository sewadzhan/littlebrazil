import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:littlebrazil/logic/blocs/network/network_bloc.dart';
import 'package:littlebrazil/view/components/auth_screen/login_section.dart';
import 'package:littlebrazil/view/components/auth_screen/otp_section.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    //Changing theme for small devices
    // Constants.checkThemeForSmallDevices(
    //     size.width, MediaQuery.of(context).devicePixelRatio);

    //Check initial connection status
    context.read<NetworkBloc>().add(ConnectionInitialChecked());

    return BlocListener<NetworkBloc, NetworkState>(
      listener: (context, state) {
        if (state is ConnectionFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(Constants.noWifiSnackBar(context));
        } else if (state is ConnectionSuccess) {
          ScaffoldMessenger.of(context).clearSnackBars();
        }
      },
      child: Scaffold(
        backgroundColor: Constants.primaryColor,
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                  top: Constants.defaultPadding * -1,
                  left: 0,
                  width: size.width,
                  height: size.height,
                  child: SvgPicture.asset('assets/decorations/auth-bg.svg')),
              Wrap(
                children: [
                  Container(
                    height: Constants.defaultPadding * 30,
                    padding: EdgeInsets.only(
                        top: Constants.defaultPadding * 1.5,
                        bottom: Constants.defaultPadding * 0.5),
                    decoration: const BoxDecoration(
                        color: Constants.backgroundColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    child: PageView(
                      controller: pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: const [LoginSection(), OTPSection()],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
