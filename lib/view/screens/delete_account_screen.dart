import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/logic/blocs/current_user/current_user_bloc.dart';
import 'package:littlebrazil/logic/cubits/auth/logout_cubit.dart';
import 'package:littlebrazil/logic/cubits/navigation/navigation_cubit.dart';
import 'package:littlebrazil/view/components/custom_outlined_button.dart';
import 'package:littlebrazil/view/components/sliver_body.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    return SliverBody(
      title: appLocalization.deleteAccount,
      bottomBar: SafeArea(
        child: Container(
            padding: EdgeInsets.all(Constants.defaultPadding),
            decoration: const BoxDecoration(
                color: Constants.backgroundColor,
                border: Border(
                    top:
                        BorderSide(color: Constants.lightGrayColor, width: 1))),
            child: CustomOutlinedButton(
                text: appLocalization.deleteAccount,
                function: () {
                  try {
                    context
                        .read<AuthCubit>()
                        .deleteUser(); //Delete in Firebase Authentication
                    context.read<CurrentUserBloc>().add(
                        CurrentUserRemoved()); //Delete personal data in Firebase Cloud Firestore
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/auth');
                    context.read<NavigationCubit>().setIndex(0);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        Constants.errorSnackBar(
                            context, appLocalization.accountDeletionError,
                            duration: const Duration(milliseconds: 500)));
                  }
                })),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: Constants.defaultPadding,
              right: Constants.defaultPadding,
              bottom: Constants.defaultPadding * 0.5,
            ),
            child: Text(
              appLocalization.confirmAccountDeletion,
              style: Constants.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
