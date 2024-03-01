import 'package:flutter/material.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget.rectangular({
    Key? key,
    this.width = double.infinity,
    this.height = 10,
    this.decoration = const BoxDecoration(
      color: Constants.lightGrayColor,
      borderRadius: BorderRadius.all(Radius.circular(6)),
    ),
  }) : super(key: key);

  final double width;
  final double height;
  final BoxDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Constants.lightGrayColor,
        highlightColor: const Color(0xFFF8F8F8),
        child: Container(
          width: width,
          height: height,
          decoration: decoration,
        ));
  }
}
