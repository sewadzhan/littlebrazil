import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:littlebrazil/view/config/constants.dart';

class BookingListTile extends StatelessWidget {
  const BookingListTile({
    super.key,
    required this.text,
    required this.title,
    required this.iconPath,
  });

  final String text;
  final String title;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Constants.defaultPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Constants.secondBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Container(
              padding: EdgeInsets.all(Constants.defaultPadding * 0.75),
              child: SvgPicture.asset(
                iconPath,
                width: 25,
                colorFilter: const ColorFilter.mode(
                    Constants.darkGrayColor, BlendMode.srcIn),
              ),
            ),
          ),
          SizedBox(
            width: Constants.defaultPadding * 0.75,
          ),
          Padding(
            padding: EdgeInsets.only(top: Constants.defaultPadding * 0.25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(bottom: Constants.defaultPadding * 0.15),
                  child: Text(
                    title,
                    style: Constants.textTheme.headlineSmall,
                  ),
                ),
                Text(
                  text,
                  style: Constants.textTheme.bodyLarge,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
