import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/logic/cubits/about_restaurant/about_restaurant_cubit.dart';
import 'package:littlebrazil/view/components/sliver_body.dart';
import 'package:littlebrazil/view/config/constants.dart';

class AboutRestaurantScreen extends StatelessWidget {
  const AboutRestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SliverBody(
        title: "О ресторане",
        child: BlocBuilder<AboutRestaurantCubit, AboutRestaurantState>(
          builder: (context, state) {
            if (state is AboutRestaurantLoadedState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: Constants.defaultPadding * 1.5),
                    child: CarouselSlider(
                        items: state.aboutRestaurantModel.images
                            .map(
                              (url) => ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(6),
                                  ),
                                  child: CachedNetworkImage(
                                    width: size.width,
                                    height: size.height * 0.4,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                            colorFilter: const ColorFilter.mode(
                                                Constants.lightGrayColor,
                                                BlendMode.colorBurn)),
                                      ),
                                    ),
                                    placeholder: (context, url) => Container(
                                      color: Constants.lightGrayColor,
                                    ),
                                    imageUrl: url,
                                  )),
                            )
                            .toList(),
                        options: CarouselOptions(
                          height: 220,
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.91,
                          initialPage: 0,
                          enableInfiniteScroll: false,
                          reverse: false,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.17,
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: Constants.defaultPadding,
                        bottom: Constants.defaultPadding * 0.5),
                    child: Text(
                      "Наша история",
                      style: Constants.headlineTextTheme.displaySmall!
                          .copyWith(color: Constants.primaryColor),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: Constants.defaultPadding,
                        bottom: Constants.defaultPadding),
                    child: Text(
                      state.aboutRestaurantModel.ourHistory,
                      style: Constants.textTheme.bodyMedium,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: Constants.defaultPadding,
                        bottom: Constants.defaultPadding * 0.5),
                    child: Text(
                      "Наша команда",
                      style: Constants.headlineTextTheme.displaySmall!
                          .copyWith(color: Constants.primaryColor),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          left: Constants.defaultPadding,
                          right: Constants.defaultPadding,
                          bottom: Constants.defaultPadding * 0.5),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 4,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: Constants.defaultPadding * 0.75),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6)),
                                    border: Border.all(
                                        color: Constants.secondPrimaryColor,
                                        width: 1)),
                                child: Column(
                                  children: [
                                    Text(
                                      state.aboutRestaurantModel.numOfExperience
                                          .toString(),
                                      style: Constants
                                          .headlineTextTheme.displaySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w600,
                                              height: 1),
                                    ),
                                    Text(
                                      "лет опыта",
                                      style: Constants.textTheme.bodyLarge!
                                          .copyWith(
                                              color:
                                                  Constants.secondPrimaryColor,
                                              height: 0.75),
                                    ),
                                  ],
                                ),
                              )),
                          SizedBox(
                            width: Constants.defaultPadding * 0.5,
                          ),
                          Expanded(
                              flex: 3,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: Constants.defaultPadding * 0.75),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(6)),
                                    border: Border.all(
                                        color: Constants.secondPrimaryColor,
                                        width: 1)),
                                child: Column(
                                  children: [
                                    Text(
                                      state.aboutRestaurantModel.numOfChiefs
                                          .toString(),
                                      style: Constants
                                          .headlineTextTheme.displaySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w600,
                                              height: 1),
                                    ),
                                    Text(
                                      "шеф-поваров",
                                      style: Constants.textTheme.bodyLarge!
                                          .copyWith(
                                              color:
                                                  Constants.secondPrimaryColor,
                                              height: 0.75),
                                    ),
                                  ],
                                ),
                              ))
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                          left: Constants.defaultPadding,
                          right: Constants.defaultPadding,
                          bottom: Constants.defaultPadding * 0.5),
                      child: Row(
                        children: [
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: Constants.defaultPadding * 0.75),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(6)),
                                border: Border.all(
                                    color: Constants.secondPrimaryColor,
                                    width: 1)),
                            child: Column(
                              children: [
                                Text(
                                  state.aboutRestaurantModel.numOfEmployees
                                      .toString(),
                                  style: Constants
                                      .headlineTextTheme.displaySmall!
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          height: 1),
                                ),
                                Text(
                                  "сотрудников",
                                  style: Constants.textTheme.bodyLarge!
                                      .copyWith(
                                          color: Constants.secondPrimaryColor,
                                          height: 0.75),
                                ),
                              ],
                            ),
                          )),
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Constants.defaultPadding,
                        vertical: Constants.defaultPadding),
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.aboutRestaurantModel.employees.length,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(
                              bottom: Constants.defaultPadding * 0.5),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: CachedNetworkImageProvider(state
                                        .aboutRestaurantModel
                                        .employees[index]
                                        .imageUrl),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: Constants.defaultPadding * 0.5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.aboutRestaurantModel.employees[index]
                                        .name,
                                    style: Constants.textTheme.bodyMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: Constants.blackColor),
                                  ),
                                  Text(
                                    state.aboutRestaurantModel.employees[index]
                                        .position,
                                    style: Constants.textTheme.bodySmall!
                                        .copyWith(
                                            color:
                                                Constants.secondPrimaryColor),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
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
        ));
  }
}