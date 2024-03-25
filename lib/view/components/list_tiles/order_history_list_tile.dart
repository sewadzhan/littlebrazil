import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:littlebrazil/data/models/order.dart';

import 'package:littlebrazil/view/config/constants.dart';

class OrderHistoryListTile extends StatelessWidget {
  const OrderHistoryListTile({
    super.key,
    required this.order,
  });

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: Text(
            "№${order.id}",
            style: Constants.textTheme.headlineSmall,
          ),
          subtitle: Text(
            DateFormat('dd.MM.yyyy, kk:mm').format(order.dateTime),
            style: Constants.textTheme.bodySmall!
                .copyWith(color: Constants.middleGrayColor),
          ),
          trailing: Text(
            order.cashbackUsed > 0
                ? "+${order.cashbackUsed} Б"
                : "${order.cashbackUsed} Б",
            style: Constants.headlineTextTheme.displaySmall!.copyWith(
                color: Constants.secondPrimaryColor,
                fontWeight: FontWeight.w600),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/orderDetails', arguments: order);
          },
        ),
        const Divider(
          height: 1,
          color: Constants.lightGrayColor,
        )
      ],
    );
  }
}
