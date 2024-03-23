import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:littlebrazil/view/components/custom_elevated_button.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateAppBottomSheet extends StatelessWidget {
  final String playMarketUrl;
  final String appStoreUrl;

  const UpdateAppBottomSheet({
    required this.playMarketUrl,
    required this.appStoreUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        SafeArea(
          child: Container(
              decoration: const BoxDecoration(
                  color: Constants.backgroundColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              padding: EdgeInsets.only(
                left: Constants.defaultPadding,
                right: Constants.defaultPadding,
                top: Constants.defaultPadding * 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.only(
                          bottom: Constants.defaultPadding * 1.5),
                      width: 150,
                      child: SvgPicture.asset('assets/logo/logo-dark.svg')),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: Constants.defaultPadding * 0.25),
                    child: Text(
                      "Доступно обновление",
                      style: Constants.textTheme.displaySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: Constants.defaultPadding * 1.5),
                    child: Text(
                      "Обновите приложение для дальнейшей работы",
                      style: Constants.textTheme.headlineMedium!
                          .copyWith(fontWeight: FontWeight.normal),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: Constants.defaultPadding * 0.25,
                    ),
                    child: CustomElevatedButton(
                        text: "Обновить",
                        function: () {
                          if (Platform.isAndroid) {
                            _launchURL(playMarketUrl);
                          } else if (Platform.isIOS) {
                            _launchURL(appStoreUrl);
                          }
                        }),
                  )
                ],
              )),
        ),
      ],
    );
  }

  void _launchURL(String str) async {
    var url = Uri.parse(str);
    await canLaunchUrl(url)
        ? await launchUrl(url)
        : throw 'Could not launch $url';
  }
}
