import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:littlebrazil/data/models/story_screen_argument.dart';
import 'package:littlebrazil/data/models/story_sections.dart';
import 'package:littlebrazil/view/components/shimmer_widgets/shimmer_widget.dart';
import 'package:littlebrazil/view/config/constants.dart';

class StoriesCarousel extends StatelessWidget {
  const StoriesCarousel(
      {super.key, required this.storySections, this.isLoading = false});

  final List<StorySection> storySections;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.only(right: Constants.defaultPadding),
              child: Row(
                children: storySections
                    .mapIndexed((index, StorySection storySection) => InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, "/story",
                                arguments: StoryScreenArgument(
                                    storySections: storySections,
                                    start: index));
                          },
                          child: Container(
                            width: 90,
                            height: 115,
                            margin:
                                EdgeInsets.only(left: Constants.defaultPadding),
                            decoration: BoxDecoration(
                                color: Constants.lightGrayColor,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                    storySection.imageUrl,
                                    errorListener: (p0) {
                                      log(p0.toString());
                                    },
                                  ),
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(6))),
                          ),
                        ))
                    .toList(),
              ),
            ),
          )
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.only(right: Constants.defaultPadding),
              child: Row(
                children: List.generate(
                    4,
                    (index) => Padding(
                          padding:
                              EdgeInsets.only(left: Constants.defaultPadding),
                          child: const ShimmerWidget.rectangular(
                            width: 90,
                            height: 115,
                          ),
                        )),
              ),
            ),
          );
  }
}
