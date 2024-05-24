import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:littlebrazil/view/components/auth_screen/login_section.dart';
import 'package:littlebrazil/view/components/auth_screen/otp_section.dart';
import 'package:littlebrazil/view/config/constants.dart';

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

    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              top: 0,
              child: SvgPicture.asset(
                'assets/decorations/auth-bg.svg',
                width: size.width,
                fit: BoxFit.cover,
              ),
            ),
            Wrap(
              children: [
                Container(
                  height: Constants.defaultPadding * 28,
                  padding: EdgeInsets.only(
                      top: Constants.defaultPadding,
                      bottom: Constants.defaultPadding * 0.5),
                  decoration: const BoxDecoration(
                      color: Constants.backgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  child: PageView(
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      LoginSection(
                        pageController: pageController,
                      ),
                      OTPSection(
                        pageController: pageController,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
