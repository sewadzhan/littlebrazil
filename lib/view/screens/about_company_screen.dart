import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/logic/cubits/about_company/about_company_cubit.dart';
import 'package:littlebrazil/view/components/list_tiles/profile_list_tile.dart';
import 'package:littlebrazil/view/components/shimmer_widgets/shimmer_list_tile.dart';
import 'package:littlebrazil/view/components/sliver_body.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutCompanyScreen extends StatelessWidget {
  const AboutCompanyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    return SliverBody(
      title: appLocalization.aboutCompany,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Constants.defaultPadding),
          child: BlocBuilder<AboutCompanyCubit, AboutCompanyState>(
            builder: (context, state) {
              if (state is AboutCompanyLoadedState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileListTile(
                        title: appLocalization.aboutCompany,
                        routeName: '',
                        urlForLaunch: state.aboutCompanyModel.companyInfoUrl),
                    ProfileListTile(
                        title: appLocalization.offer,
                        routeName: '',
                        urlForLaunch: state.aboutCompanyModel.offerUrl),
                    ProfileListTile(
                        title: appLocalization.privacyPolicy,
                        routeName: '',
                        urlForLaunch: state.aboutCompanyModel.policyUrl),
                    ProfileListTile(
                        title: appLocalization.paymentTerms,
                        routeName: '',
                        urlForLaunch: state.aboutCompanyModel.paymentTermsUrl),
                    ProfileListTile(
                        title: appLocalization.deliveryTerms,
                        routeName: '',
                        urlForLaunch: state.aboutCompanyModel.deliveryTermsUrl)
                  ],
                );
              }
              return Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: Constants.defaultPadding),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Constants.defaultPadding * 0.75),
                    child: const ShimmerListTile(),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
