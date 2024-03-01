import 'package:flutter/material.dart';
import 'package:littlebrazil/view/components/shimmer_widgets/shimmer_widget.dart';
import 'package:littlebrazil/view/config/constants.dart';

class ShimmerListTile extends StatelessWidget {
  const ShimmerListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(
        children: [
          const ShimmerWidget.rectangular(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Constants.lightGrayColor,
            ),
          ),
          SizedBox(width: Constants.defaultPadding * 0.75),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerWidget.rectangular(
                width: 80,
                height: 15,
              ),
              SizedBox(height: 10),
              ShimmerWidget.rectangular(
                width: 200,
                height: 15,
              )
            ],
          ),
        ],
      ),
    ]);
  }
}
