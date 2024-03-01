import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:littlebrazil/data/models/category.dart';
import 'package:littlebrazil/view/config/constants.dart';

class CategoryMenuSliverHeader extends SliverPersistentHeaderDelegate {
  final void Function(int, List<Category>) function;
  final int selectedIndex;
  final List<Category> categories;

  CategoryMenuSliverHeader(
      {required this.function,
      required this.selectedIndex,
      required this.categories});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return CategoryMenu(
        function: function,
        selectedIndex: selectedIndex,
        categories: categories,
        overlapsContent: overlapsContent);
  }

  @override
  double get maxExtent => 52;

  @override
  double get minExtent => 52;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class CategoryMenu extends StatefulWidget {
  const CategoryMenu(
      {super.key,
      required this.function,
      required this.selectedIndex,
      required this.categories,
      required this.overlapsContent});

  final void Function(int, List<Category>) function;
  final int selectedIndex;
  final List<Category> categories;
  final bool overlapsContent;

  @override
  State<CategoryMenu> createState() => _CategoryMenuState();
}

class _CategoryMenuState extends State<CategoryMenu> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CategoryMenu oldWidget) {
    scrollController.animateTo(50.0 * widget.selectedIndex,
        duration: const Duration(milliseconds: 150), curve: Curves.linear);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Constants.defaultPadding * 0.75),
      decoration: BoxDecoration(
          color: Constants.backgroundColor,
          border: Border(
              bottom: BorderSide(
                  color: widget.overlapsContent
                      ? Constants.lightGrayColor
                      : Constants.backgroundColor,
                  width: 1))),
      child: Row(
        children: [
          SizedBox(
            width: 45,
            child: TextButton(
              style: TextButton.styleFrom(
                shape: const CircleBorder(),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              },
              child: SizedBox(
                width: 25,
                child: SvgPicture.asset(
                  'assets/icons/search.svg',
                  colorFilter: const ColorFilter.mode(
                      Constants.darkGrayColor, BlendMode.srcIn),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: List.generate(
                      widget.categories.length,
                      (index) => InkWell(
                            onTap: () {
                              widget.function(index, widget.categories);
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  right: Constants.defaultPadding * 0.75),
                              decoration: BoxDecoration(
                                  color: Constants.secondBackgroundColor,
                                  border: Border.all(
                                      width: 1,
                                      color: index == widget.selectedIndex
                                          ? Constants.secondPrimaryColor
                                          : Colors.transparent),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(6))),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                widget.categories[index].name,
                                style: Constants.textTheme.headlineSmall!
                                    .copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: index == widget.selectedIndex
                                            ? Constants.secondPrimaryColor
                                            : Constants.darkGrayColor),
                              ),
                            ),
                          ))),
            ),
          ),
        ],
      ),
    );
  }
}
