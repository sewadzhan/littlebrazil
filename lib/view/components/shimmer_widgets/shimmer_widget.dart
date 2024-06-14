import 'package:flutter/material.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget.rectangular({
    super.key,
    this.width = double.infinity,
    this.height = 10,
    this.baseColor = Constants.lightGrayColor,
    this.decoration = const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  });

  final double width;
  final double height;
  final BoxDecoration decoration;
  final Color baseColor;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: const Color(0xFFF8F8F8),
        child: Container(
          width: width,
          height: height,
          decoration: decoration.copyWith(color: baseColor),
        ));
  }
}
