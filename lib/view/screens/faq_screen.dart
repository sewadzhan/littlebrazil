import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/logic/blocs/faq/faq_bloc.dart';
import 'package:littlebrazil/logic/cubits/localization/localization_cubit.dart';
import 'package:littlebrazil/view/components/list_tiles/faq_list_tile.dart';
import 'package:littlebrazil/view/components/sliver_body.dart';
import 'package:littlebrazil/view/config/constants.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Locale currentLocale = context.read<LocalizationCubit>().state.locale;
    return SliverBody(
      title: "FAQ",
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: BlocConsumer<FAQBloc, FAQState>(
          listener: (context, state) {
            if (state is FAQErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                  Constants.errorSnackBar(context, state.message,
                      duration: const Duration(milliseconds: 1600)));
            }
          },
          builder: (context, state) {
            if (state is FAQLoaded) {
              if (state.faqModels.isEmpty) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: EdgeInsets.only(
                  left: Constants.defaultPadding,
                  right: Constants.defaultPadding,
                  bottom: Constants.defaultPadding,
                ),
                child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: state.faqModels.length,
                    itemBuilder: (context, index) => FAQListTile(
                          faq: state.faqModels[index],
                          locale: currentLocale,
                        )),
              );
            }
            return Padding(
              padding: EdgeInsets.all(Constants.defaultPadding),
              child: const Center(
                child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      color: Constants.secondPrimaryColor,
                      strokeWidth: 2.5,
                    )),
              ),
            );
          },
        ),
      ),
    );
  }
}
