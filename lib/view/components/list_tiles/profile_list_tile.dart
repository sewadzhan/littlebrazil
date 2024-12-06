import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/logic/blocs/current_user/current_user_bloc.dart';
import 'package:littlebrazil/logic/cubits/auth/logout_cubit.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileListTile extends StatelessWidget {
  const ProfileListTile(
      {super.key,
      required this.title,
      required this.routeName,
      this.pushWithRemove = false,
      this.urlForLaunch = ""});

  final String title;
  final String routeName;
  final bool pushWithRemove;
  final String urlForLaunch;

  void launchURL(String str) async {
    var url = Uri.parse(str);
    await canLaunchUrl(url)
        ? await launchUrl(url)
        : throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    return Column(
      children: [
        ListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          title: Text(
            title,
            style: pushWithRemove
                ? Constants.textTheme.headlineSmall!
                    .copyWith(color: Constants.secondPrimaryColor)
                : Constants.textTheme.headlineSmall,
          ),
          trailing: Padding(
            padding: EdgeInsets.only(right: Constants.defaultPadding * 0.5),
            child: SvgPicture.asset(
              'assets/icons/arrow-right.svg',
            ),
          ),
          onTap: () {
            if (pushWithRemove) {
              Constants.showBottomSheetAlert(
                  context: context,
                  title: appLocalization.doYouWantToLogout,
                  submit: appLocalization.logout,
                  cancel: appLocalization.cancel,
                  function: () {
                    Navigator.of(context).pop();
                    context.read<AuthCubit>().signOut();
                    context.read<CurrentUserBloc>().add(CurrentUserSignedOut());
                  });

              return;
            } else if (urlForLaunch.isNotEmpty) {
              launchURL(urlForLaunch);
              return;
            }
            Navigator.pushNamed(context, routeName);
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
