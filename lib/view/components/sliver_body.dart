import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:littlebrazil/view/config/constants.dart';

class SliverBody extends StatelessWidget {
  const SliverBody(
      {Key? key,
      required this.title,
      required this.child,
      this.bottomBar = const SizedBox.shrink(),
      this.actions = const [],
      this.showBackButton = true,
      this.floatingActionButton = const SizedBox.shrink()})
      : super(key: key);

  final String title;
  final Widget child;
  final Widget bottomBar;
  final Widget floatingActionButton;
  final bool showBackButton;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    final ValueNotifier<double> titlePaddingNotifier = ValueNotifier(15.0);

    scrollController.addListener(() {
      final kExpandedHeight = showBackButton ? 105 : 75;
      const double kBasePadding = 13;
      const double kCollapsedPadding = 65;
      final double horizontalTitlePadding;

      if (scrollController.hasClients) {
        horizontalTitlePadding = min(
            kBasePadding + kCollapsedPadding,
            kBasePadding +
                (kCollapsedPadding * scrollController.offset) /
                    (kExpandedHeight - kToolbarHeight));
      } else {
        horizontalTitlePadding = kBasePadding;
      }
      titlePaddingNotifier.value = horizontalTitlePadding;
    });

    return Scaffold(
      floatingActionButton: floatingActionButton,
      extendBodyBehindAppBar: !showBackButton,
      backgroundColor: Constants.backgroundColor,
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        controller: scrollController,
        slivers: [
          SliverAppBar(
            leading: showBackButton
                ? TextButton(
                    style: TextButton.styleFrom(
                      shape: const CircleBorder(),
                    ),
                    child: SizedBox(
                      width: 25,
                      child: SvgPicture.asset('assets/icons/arrow-left.svg',
                          colorFilter: const ColorFilter.mode(
                              Constants.darkGrayColor, BlendMode.srcIn)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                : const SizedBox.shrink(),
            actions: actions,
            backgroundColor: Constants.backgroundColor,
            expandedHeight: showBackButton ? 140 : 90,
            scrolledUnderElevation: 0,
            forceElevated: true,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 1.25,
              collapseMode: CollapseMode.pin,
              centerTitle: false,
              titlePadding: EdgeInsets.only(
                  top: Constants.defaultPadding * 0.75,
                  bottom: Constants.defaultPadding * 0.6,
                  left: 0,
                  right: 0),
              title: ValueListenableBuilder(
                valueListenable: titlePaddingNotifier,
                builder: (context, double value, child) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: value),
                    child: Text(title,
                        style: Constants.headlineTextTheme.displayLarge!
                            .copyWith(
                                color: Constants.primaryColor, fontSize: 29)),
                  );
                },
              ),
            ),
          ),
          SliverPadding(
              padding: EdgeInsets.only(top: Constants.defaultPadding * 0.5),
              sliver: SliverToBoxAdapter(child: child))
        ],
      ),
      bottomNavigationBar: bottomBar,
    );
  }
}
