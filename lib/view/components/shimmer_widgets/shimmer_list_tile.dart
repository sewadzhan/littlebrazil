import 'package:flutter/material.dart';
import 'package:littlebrazil/view/components/shimmer_widgets/shimmer_widget.dart';

class ShimmerListTile extends StatelessWidget {
  const ShimmerListTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerWidget.rectangular(
                    width: 100,
                    height: 15,
                  ),
                  SizedBox(height: 10),
                  ShimmerWidget.rectangular(
                    width: 250,
                    height: 15,
                  )
                ],
              ),
            ],
          ),
        ]);
  }
}
