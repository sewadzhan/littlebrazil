import 'package:flutter/material.dart';

import 'package:littlebrazil/data/models/faq_model.dart';
import 'package:littlebrazil/view/config/constants.dart';

class FAQListTile extends StatelessWidget {
  const FAQListTile({
    super.key,
    required this.faq,
  });

  final FAQModel faq;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
          dense: true,
          shape: const Border(),
          tilePadding: EdgeInsets.zero,
          iconColor: Constants.secondPrimaryColor,
          collapsedIconColor: Constants.middleGrayColor,
          childrenPadding: EdgeInsets.only(bottom: Constants.defaultPadding),
          title: Text(
            faq.question,
            style: Constants.textTheme.headlineSmall,
          ),
          children: [
            Text(
              faq.answer,
              style: Constants.textTheme.bodyLarge,
            )
          ],
        ),
        const Divider(
          height: 1,
          color: Constants.lightGrayColor,
        )
      ],
    );
  }
}
