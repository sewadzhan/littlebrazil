import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:littlebrazil/logic/blocs/search/search_bloc.dart';
import 'package:littlebrazil/view/components/product_card.dart';
import 'package:littlebrazil/view/config/constants.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //For delay in onChanged TextFormField method
    var searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        shape: const Border(
            bottom: BorderSide(color: Constants.lightGrayColor, width: 1)),
        elevation: 0,
        backgroundColor: Constants.backgroundColor,
        leading: TextButton(
          style: TextButton.styleFrom(
            shape: const CircleBorder(),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: SizedBox(
            width: 25,
            child: SvgPicture.asset(
              'assets/icons/cross.svg',
              colorFilter: const ColorFilter.mode(
                  Constants.darkGrayColor, BlendMode.srcIn),
            ),
          ),
        ),
        title: TextFormField(
            autofocus: true,
            controller: searchController,
            decoration: InputDecoration.collapsed(
                hintText: 'Поиск', hintStyle: Constants.textTheme.bodyLarge),
            onChanged: (query) {
              context
                  .read<SearchBloc>()
                  .add(SearchProducts(searchController.text));
            }),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: Constants.defaultPadding,
          ),
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is SearchInitial) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Constants.defaultPadding),
                  child: Text("Что будем искать?",
                      style: Constants.headlineTextTheme.displayMedium!
                          .copyWith(color: Constants.primaryColor)),
                );
              } else if (state is SearchLoading) {
                return Padding(
                  padding: EdgeInsets.only(top: Constants.defaultPadding),
                  child: const Center(
                      child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      color: Constants.secondPrimaryColor,
                      strokeWidth: 2.5,
                    ),
                  )),
                );
              } else if (state is SearchSuccess) {
                if (state.products.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Constants.defaultPadding),
                    child: Text("Ничего не найдено",
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
                      child: Text("Результаты поиска",
                          style: Constants.headlineTextTheme.displayMedium!
                              .copyWith(color: Constants.primaryColor)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Constants.defaultPadding * 0.5),
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.products.length,
                          itemBuilder: (context, productIndex) {
                            var product = state.products[productIndex];
                            return ProductCard(
                                product: product, isShownInSearchScreen: true);
                          }),
                    )
                  ],
                );
              } else if (state is SearchFailed) {
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
