import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:littlebrazil/logic/blocs/suggest_address/suggest_address_bloc.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SuggestAddressScreen extends StatelessWidget {
  const SuggestAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    var searchController =
        TextEditingController(); //For delay in onChanged TextFormField method

    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          style: TextButton.styleFrom(
            shape: const CircleBorder(),
          ),
          child: SizedBox(
            width: 25,
            child: SvgPicture.asset(
              'assets/icons/arrow-left.svg',
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        shape: const Border(
            bottom: BorderSide(color: Constants.lightGrayColor, width: 1)),
        elevation: 0,
        backgroundColor: Constants.backgroundColor,
        title: TextFormField(
            autofocus: true,
            controller: searchController,
            decoration: InputDecoration.collapsed(
                hintText: appLocalization.address,
                hintStyle: Constants.textTheme.bodyLarge),
            onChanged: (query) {
              context
                  .read<SuggestAddressBloc>()
                  .add(SuggestAddress(searchController.text));
            }),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: Constants.defaultPadding,
          ),
          child: BlocBuilder<SuggestAddressBloc, SuggestAddressState>(
            builder: (context, state) {
              if (state is SuggestAddressInitial) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Constants.defaultPadding),
                  child: Text(appLocalization.specifyDeliveryAddress,
                      style: Constants.headlineTextTheme.displayMedium!
                          .copyWith(color: Constants.primaryColor)),
                );
              } else if (state is SuggestAddressLoading) {
                return Padding(
                  padding: EdgeInsets.only(top: Constants.defaultPadding),
                  child: const Center(
                      child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Constants.secondPrimaryColor,
                    ),
                  )),
                );
              } else if (state is SuggestAddressSuccess) {
                if (state.addresses.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Constants.defaultPadding),
                    child: Text(appLocalization.nothingFound,
                        style: Constants.headlineTextTheme.displayMedium!
                            .copyWith(color: Constants.primaryColor)),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: Constants.defaultPadding,
                          right: Constants.defaultPadding,
                          bottom: Constants.defaultPadding),
                      child: Text(appLocalization.searchResults,
                          style: Constants.headlineTextTheme.displayMedium!
                              .copyWith(color: Constants.primaryColor)),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Constants.defaultPadding * 0.5),
                        child: ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: state.addresses.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  Navigator.pop(
                                      context, state.addresses[index]);
                                },
                                title: Text(
                                  state.addresses[index],
                                  style: Constants.textTheme.bodyLarge,
                                ),
                              );
                            }))
                  ],
                );
              } else if (state is SuggestAddressFailed) {
                return Center(child: Text(state.message));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
