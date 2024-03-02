import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:littlebrazil/view/config/constants.dart';

class NotWorkingBottomSheet extends StatelessWidget {
  const NotWorkingBottomSheet({
    Key? key,
    required this.openHour,
    required this.closeHour,
  }) : super(key: key);

  final String openHour;
  final String closeHour;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 250,
        padding: EdgeInsets.only(
          top: Constants.defaultPadding * 0.5,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                bottom: 0,
                left: 0,
                child: SvgPicture.asset(
                    'assets/decorations/notworking-bottom-left.svg')),
            Positioned(
                top: 0,
                right: 0,
                child: SvgPicture.asset(
                  'assets/decorations/notworking-top-right.svg',
                  width: 100,
                )),
            Positioned(
                bottom: 0,
                right: 0,
                child: SvgPicture.asset(
                    'assets/decorations/notworking-bottom-right.svg')),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      bottom: Constants.defaultPadding,
                      top: Constants.defaultPadding * 2.5),
                  child: Text(
                    "На данный момент\n доставка не работает",
                    style: Constants.textTheme.headlineMedium!
                        .copyWith(height: 1.25),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(bottom: Constants.defaultPadding * 2),
                  child: Text(
                    "График работы:\nс $openHour до $closeHour",
                    style: Constants.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Понятно",
                      style: Constants.textTheme.titleLarge!.copyWith(
                          fontSize: 12, decoration: TextDecoration.underline),
                    ))
              ],
            ),
          ],
        ));
  }
}
