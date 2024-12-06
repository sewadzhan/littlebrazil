import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/data/models/category.dart';
import 'package:littlebrazil/logic/cubits/bottom_sheet/bottom_sheet_cubit.dart';
import 'package:littlebrazil/logic/cubits/menu/menu_cubit.dart';
import 'package:littlebrazil/logic/cubits/stories/stories_cubit.dart';
import 'package:littlebrazil/view/components/bottom_sheets/not_working_bottom_sheet.dart';
import 'package:littlebrazil/view/components/bottom_sheets/update_app_bottom_sheet.dart';
import 'package:littlebrazil/view/components/home_screen/category_menu.dart';
import 'package:littlebrazil/view/components/home_screen/category_section.dart';
import 'package:littlebrazil/view/components/home_screen/home_screen_app_bar.dart';
import 'package:littlebrazil/view/components/home_screen/stories_carousel.dart';
import 'package:littlebrazil/view/components/shimmer_widgets/shimmer_widget.dart';
import 'package:littlebrazil/view/config/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController scrollController;
  late void Function() scrollControllerListener;
  late int selectedCategoryIndex;
  late double promotionHeight;
  late double productCardHeight;
  late List<double> breakPoints; //BreakPoints of each CategorySection

  @override
  void initState() {
    scrollController = ScrollController();
    selectedCategoryIndex = 0;
    promotionHeight = 99 + 52; //52 (CategoryMenu height)
    productCardHeight = Constants.defaultPadding * 9.125 + 6;
    breakPoints = [];
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BottomSheetCubit, BottomSheetState>(
      listener: (context, bottomSheetState) {
        if (bottomSheetState is NotWorkingBottomSheetShowState) {
          showModalBottomSheet(
              context: context,
              backgroundColor: Constants.backgroundColor,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              builder: (context) => NotWorkingBottomSheet(
                    openHour: bottomSheetState.openHour,
                    closeHour: bottomSheetState.closeHour,
                  ));
        } else if (bottomSheetState is UpdateAppBottomSheetShowState) {
          showModalBottomSheet(
              backgroundColor: Constants.backgroundColor,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              isScrollControlled: true,
              isDismissible: false,
              enableDrag: false,
              context: context,
              builder: (context) => UpdateAppBottomSheet(
                  playMarketUrl: bottomSheetState.playMarketUrl,
                  appStoreUrl: bottomSheetState.appStoreUrl));
        }
      },
      child: Scaffold(
        body: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          controller: scrollController,
          slivers: [
            const HomeScreenAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(
                    top: Constants.defaultPadding * 0.75,
                    bottom: Constants.defaultPadding),
                child: BlocBuilder<StoriesCubit, StoriesState>(
                  builder: (context, storiesState) {
                    if (storiesState is StoriesLoadedState) {
                      return StoriesCarousel(
                        storySections: storiesState.storySections,
                      );
                    }
                    return const StoriesCarousel(
                      isLoading: true,
                      storySections: [],
                    );
                  },
                ),
              ),
            ),
            BlocBuilder<MenuCubit, MenuState>(builder: (context, state) {
              if (state is MenuLoadedState) {
                //Initialising break points for correct navigation
                if (breakPoints.isEmpty) {
                  createBreakPoints(state.categories);
                  scrollControllerListener = () {
                    updateCategoryIndexOnScroll(
                        scrollController.offset, state.categories);
                  };
                  scrollController.addListener(scrollControllerListener);
                }

                return SliverPersistentHeader(
                    pinned: true,
                    delegate: CategoryMenuSliverHeader(
                        function: scrollToCategory,
                        selectedIndex: selectedCategoryIndex,
                        categories: state.categories));
              }
              return SliverToBoxAdapter(
                child: SizedBox(
                    height: 52,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(
                            5,
                            (i) => const ShimmerWidget.rectangular(
                              width: 70,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Constants.lightGrayColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                              ),
                            ),
                          )),
                    )),
              );
            }),
            BlocBuilder<MenuCubit, MenuState>(builder: (context, state) {
              if (state is MenuLoadedState) {
                return SliverPadding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Constants.defaultPadding),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    return CategorySection(category: state.categories[index]);
                  }, childCount: state.categories.length)),
                );
              }
              return SliverToBoxAdapter(
                child: Center(
                  child: Container(
                      width: 25,
                      height: 25,
                      margin:
                          EdgeInsets.only(top: Constants.defaultPadding * 2),
                      child: const CircularProgressIndicator(
                        color: Constants.secondPrimaryColor,
                        strokeWidth: 2.5,
                      )),
                ),
              );
            })
          ],
        ),
      ),
    );
  }

  //Scroll page to certain product category
  void scrollToCategory(int index, List<Category> categories) {
    if (selectedCategoryIndex != index) {
      int totalRows = 0;

      for (var i = 0; i < index; i++) {
        totalRows += categories[i].products.length;
      }

      setState(() {
        selectedCategoryIndex = index;
      });

      scrollController.removeListener(scrollControllerListener);
      scrollController.jumpTo(promotionHeight +
          totalRows * productCardHeight +
          index *
              (Constants.defaultPadding * 2.65 +
                  Constants.headlineTextTheme.displayMedium!.fontSize!));

      scrollController.addListener(scrollControllerListener);
    }
  }

  //Create all breakpoints of each category section for automatic selected category change
  void createBreakPoints(List<Category> categories) {
    if (categories.isNotEmpty) {
      int totalRows1 = categories[0].products.length;
      double firstBreakPoint = promotionHeight +
          (totalRows1 * productCardHeight) +
          (Constants.defaultPadding * 2.65 +
              Constants.headlineTextTheme.displayMedium!.fontSize!);
      breakPoints.add(firstBreakPoint);

      for (var i = 1; i < categories.length; i++) {
        int totalRows = categories[i].products.length;
        double breakPoint = breakPoints.last +
            (totalRows * productCardHeight) +
            (Constants.defaultPadding * 2.65 +
                Constants.headlineTextTheme.displayMedium!.fontSize!);
        breakPoints.add(breakPoint);
      }
    }
  }

  //Update selected category index on scroll of page
  void updateCategoryIndexOnScroll(double offset, List<Category> categories) {
    for (var i = 0; i < categories.length; i++) {
      if (i == 0) {
        if ((offset < breakPoints.first) && (selectedCategoryIndex != 0)) {
          setState(() {
            selectedCategoryIndex = 0;
          });
        }
      } else if ((breakPoints[i - 1] <= offset) && (offset < breakPoints[i])) {
        if (selectedCategoryIndex != i) {
          setState(() {
            selectedCategoryIndex = i;
          });
        }
      }
    }
  }
}
