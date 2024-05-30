import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:littlebrazil/view/config/constants.dart';

enum BackButtonType { arrow, cross }

class SliverBody extends StatefulWidget {
  const SliverBody(
      {super.key,
      required this.title,
      required this.child,
      this.bottomBar,
      this.actions = const [],
      this.showBackButton = true,
      this.floatingActionButton,
      this.backButtonType = BackButtonType.arrow});

  final String title;
  final Widget child;
  final Widget? bottomBar;
  final Widget? floatingActionButton;
  final bool showBackButton;
  final List<Widget> actions;
  final BackButtonType backButtonType;

  @override
  State<SliverBody> createState() => _SliverBodyState();
}

class _SliverBodyState extends State<SliverBody> {
  static const double kBasePadding = 10;
  static const double kCollapsedPadding = 45;
  final scrollController = ScrollController();
  final ValueNotifier<double> titlePaddingNotifier = ValueNotifier(10.0);

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      final kExpandedHeight = widget.showBackButton ? 105 : 75;
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
      extendBodyBehindAppBar: !widget.showBackButton,
      backgroundColor: Constants.backgroundColor,
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        controller: scrollController,
        slivers: [
          SliverAppBar(
            leading: widget.showBackButton
                ? TextButton(
                    style: TextButton.styleFrom(
                      shape: const CircleBorder(),
                    ),
                    child: SizedBox(
                      width: 25,
                      child: SvgPicture.asset(
                          widget.backButtonType == BackButtonType.cross
                              ? 'assets/icons/cross.svg'
                              : 'assets/icons/arrow-left.svg',
                          colorFilter: const ColorFilter.mode(
                              Constants.darkGrayColor, BlendMode.srcIn)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                : const SizedBox.shrink(),
            actions: widget.actions,
            backgroundColor: Constants.backgroundColor,
            expandedHeight: widget.showBackButton
                ? Constants.defaultPadding * 8
                : Constants.defaultPadding * 6.5,
            scrolledUnderElevation: 0,
            forceElevated: true,
            floating: false,
            pinned: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: ValueListenableBuilder<double>(
                valueListenable: titlePaddingNotifier,
                builder: (context, value, _) {
                  return value == kBasePadding + kCollapsedPadding
                      ? Container(
                          color: Constants.lightGrayColor,
                          height: 1,
                        )
                      : const SizedBox.shrink();
                },
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              expandedTitleScale: 1.5,
              collapseMode: CollapseMode.pin,
              titlePadding: EdgeInsets.only(
                bottom: Constants.defaultPadding * 0.75,
              ),
              title: ValueListenableBuilder(
                valueListenable: titlePaddingNotifier,
                builder: (context, double value, child) {
                  return Padding(
                    padding: EdgeInsets.only(left: value),
                    child: Text(
                      widget.title,
                      style: Constants.headlineTextTheme.displaySmall!
                          .copyWith(color: Constants.primaryColor),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverPadding(
              padding: EdgeInsets.only(top: Constants.defaultPadding * 0),
              sliver: SliverToBoxAdapter(child: widget.child))
        ],
      ),
      bottomNavigationBar: widget.bottomBar,
      floatingActionButton: widget.floatingActionButton,
    );
  }
}
