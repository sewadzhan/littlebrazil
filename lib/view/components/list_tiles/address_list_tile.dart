import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:littlebrazil/data/models/address.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddressListTile extends StatelessWidget {
  const AddressListTile({
    super.key,
    required this.address,
    this.function,
  });

  final Address address;
  final Function()? function;

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;

    return Column(
      children: [
        ListTile(
          dense: true,
          onTap: function,
          contentPadding: EdgeInsets.zero,
          title: Text(
            address.address,
            style: Constants.textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
                color: Constants.darkGrayColor),
          ),
          subtitle: Text(
            "${appLocalization.apartmentOffice} ${address.apartmentOrOffice}",
            style: Constants.textTheme.bodyMedium!
                .copyWith(color: Constants.middleGrayColor),
          ),
          trailing: SvgPicture.asset('assets/icons/arrow-right.svg',
              colorFilter: const ColorFilter.mode(
                  Constants.middleGrayColor, BlendMode.srcIn)),
        ),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width,
          color: Constants.lightGrayColor,
        )
      ],
    );
  }
}
