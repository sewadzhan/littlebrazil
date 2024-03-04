import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:littlebrazil/logic/cubits/contacts/contacts_cubit.dart';
import 'package:littlebrazil/view/components/custom_outlined_button.dart';
import 'package:littlebrazil/view/components/shimmer_widgets/shimmer_widget.dart';
import 'package:littlebrazil/view/components/sliver_body.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  void launchURL(String str) async {
    var url = Uri.parse(str);
    await canLaunchUrl(url)
        ? await launchUrl(url)
        : throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    return SliverBody(
        title: "Контакты",
        showBackButton: false,
        child: Padding(
            padding: EdgeInsets.only(
                left: Constants.defaultPadding,
                right: Constants.defaultPadding,
                top: Constants.defaultPadding * 0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<ContactsCubit, ContactsState>(
                  builder: (context, state) {
                    if (state is ContactsLoadedState) {
                      return Column(
                          children: List.generate(
                        state.contactsModel.phones.length,
                        (index) => Padding(
                            padding: EdgeInsets.only(
                                bottom: Constants.defaultPadding / 4),
                            child: InkWell(
                              onTap: () {
                                launchURL(
                                    "tel:${state.contactsModel.phones[index]}");
                              },
                              child: Text(
                                state.contactsModel.phones[index],
                                style: Constants.textTheme.headlineMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Constants.blackColor),
                              ),
                            )),
                      ));
                    }
                    return const ShimmerWidget.rectangular(
                      width: 150,
                      height: 20,
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: Constants.defaultPadding),
                  child: BlocBuilder<ContactsCubit, ContactsState>(
                    builder: (context, state) {
                      if (state is ContactsLoadedState) {
                        return Text(
                            "Пн-Вс с ${state.contactsModel.openHour} до ${state.contactsModel.closeHour}",
                            style: Constants.textTheme.headlineSmall!.copyWith(
                                color: Constants.darkGrayColor,
                                fontWeight: FontWeight.normal));
                      }
                      return const ShimmerWidget.rectangular(
                        width: 200,
                        height: 20,
                      );
                    },
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(bottom: Constants.defaultPadding * 2),
                  child: BlocBuilder<ContactsCubit, ContactsState>(
                    builder: (context, state) {
                      if (state is ContactsLoadedState) {
                        return InkWell(
                          onTap: () {
                            launchURL(state.contactsModel.webSite);
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 30,
                                child:
                                    SvgPicture.asset('assets/icons/link.svg'),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: Text("Наш сайт",
                                      style: Constants.textTheme.headlineMedium!
                                          .copyWith(
                                        color: Constants.secondPrimaryColor,
                                        fontWeight: FontWeight.w500,
                                      )))
                            ],
                          ),
                        );
                      }
                      return const ShimmerWidget.rectangular(
                        width: 120,
                        height: 20,
                      );
                    },
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(bottom: Constants.defaultPadding * 0.75),
                  child: Text("Адреса",
                      style: Constants.headlineTextTheme.displaySmall!.copyWith(
                          fontSize: 24,
                          color: Constants.primaryColor,
                          fontWeight: FontWeight.bold)),
                ),
                BlocBuilder<ContactsCubit, ContactsState>(
                  builder: (context, state) {
                    if (state is ContactsLoadedState) {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: state.contactsModel.pickupPoints
                              .map((e) => Padding(
                                    padding: EdgeInsets.only(
                                        bottom: Constants.defaultPadding / 2),
                                    child: Text(e.address,
                                        style: Constants
                                            .textTheme.headlineMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.normal)),
                                  ))
                              .toList());
                    }
                    return Column(
                        children: List.generate(
                            1,
                            (index) => Padding(
                                  padding: EdgeInsets.only(
                                      bottom: Constants.defaultPadding / 2),
                                  child: const ShimmerWidget.rectangular(
                                    width: 250,
                                    height: 20,
                                  ),
                                )));
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: Constants.defaultPadding * 1.25,
                      bottom: Constants.defaultPadding * 0.75),
                  child: Text("Мы в социальных сетях",
                      style: Constants.headlineTextTheme.displaySmall!.copyWith(
                          fontSize: 24,
                          color: Constants.primaryColor,
                          fontWeight: FontWeight.bold)),
                ),
                BlocBuilder<ContactsCubit, ContactsState>(
                  builder: (context, state) {
                    if (state is ContactsLoadedState) {
                      return Row(children: [
                        ElevatedButton(
                          onPressed: () {
                            launchURL(state.contactsModel.instagramUrl);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(15),
                            backgroundColor: Constants.backgroundColor,
                            foregroundColor: Constants.darkGrayColor,
                            side: const BorderSide(
                              color: Constants.darkGrayColor,
                              width: 1,
                            ),
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/instagram.svg',
                            colorFilter: const ColorFilter.mode(
                                Constants.darkGrayColor, BlendMode.srcIn),
                            width: 25,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            launchURL(state.contactsModel.whatsappUrl);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(15),
                            backgroundColor: Constants.backgroundColor,
                            foregroundColor: Constants.darkGrayColor,
                            side: const BorderSide(
                                color: Constants.darkGrayColor, width: 1),
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/whatsapp.svg',
                            colorFilter: const ColorFilter.mode(
                                Constants.darkGrayColor, BlendMode.srcIn),
                            width: 25,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            launchURL(state.contactsModel.tiktokUrl);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(15),
                            backgroundColor: Constants.backgroundColor,
                            foregroundColor: Constants.darkGrayColor,
                            side: const BorderSide(
                                color: Constants.darkGrayColor, width: 1),
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/tiktok.svg',
                            colorFilter: const ColorFilter.mode(
                                Constants.darkGrayColor, BlendMode.srcIn),
                            width: 25,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            launchURL(state.contactsModel.youtubeUrl);
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(15),
                            backgroundColor: Constants.backgroundColor,
                            foregroundColor: Constants.darkGrayColor,
                            side: const BorderSide(
                                color: Constants.darkGrayColor, width: 1),
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/youtube.svg',
                            colorFilter: const ColorFilter.mode(
                                Constants.darkGrayColor, BlendMode.srcIn),
                            width: 25,
                          ),
                        ),
                      ]);
                    }
                    return Row(
                        children: List.generate(
                      4,
                      (index) => Padding(
                        padding: EdgeInsets.only(
                            right: Constants.defaultPadding * 0.75),
                        child: const ShimmerWidget.rectangular(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Constants.lightGrayColor,
                              shape: BoxShape.circle),
                        ),
                      ),
                    ));
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: Constants.defaultPadding * 2),
                  child: CustomOutlinedButton(
                      text: "О РЕСТОРАНЕ", function: () {}),
                )
              ],
            )));
  }
}
