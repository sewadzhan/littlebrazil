import 'package:flutter/material.dart';
import 'package:littlebrazil/data/models/category.dart';
import 'package:littlebrazil/data/models/product.dart';
import 'package:littlebrazil/view/components/product_card.dart';
import 'package:littlebrazil/view/config/constants.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({
    super.key,
    required this.category,
  });

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.only(
              top: Constants.defaultPadding * 1.5,
              bottom: Constants.defaultPadding,
            ),
            child: Text(category.name,
                style: Constants.headlineTextTheme.displayMedium!
                    .copyWith(color: Constants.primaryColor))),
        ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: category.products.length,
            itemBuilder: (context, productIndex) {
              var product = category.products[productIndex];
              if (product is Product) {
                return ProductCard(product: product);
              }
              return const SizedBox.shrink();
            })
      ],
    );
  }
}
