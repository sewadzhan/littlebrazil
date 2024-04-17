import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:littlebrazil/logic/blocs/address/address_bloc.dart';
import 'package:littlebrazil/logic/cubits/auth/logout_cubit.dart';
import 'package:littlebrazil/view/components/custom_outlined_button.dart';
import 'package:littlebrazil/view/components/list_tiles/address_list_tile.dart';
import 'package:littlebrazil/view/components/shimmer_widgets/shimmer_list_tile.dart';
import 'package:littlebrazil/view/components/sliver_body.dart';
import 'package:littlebrazil/view/config/constants.dart';

class MyAddressesScreen extends StatelessWidget {
  const MyAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var phoneNumber = context.read<AuthCubit>().state!.phoneNumber!;
    return SliverBody(
      title: "Мои адреса",
      bottomBar: SafeArea(
        child: Container(
            padding: EdgeInsets.all(Constants.defaultPadding),
            decoration: const BoxDecoration(
                color: Constants.backgroundColor,
                border: Border(
                    top:
                        BorderSide(color: Constants.lightGrayColor, width: 1))),
            child: CustomOutlinedButton(
                text: "ДОБАВИТЬ НОВЫЙ АДРЕС",
                function: () {
                  Navigator.pushNamed(context, '/addAddress');
                })),
      ),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: BlocConsumer<AddressBloc, AddressState>(
          listener: ((context, state) {
            if (state is AddressErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                  Constants.errorSnackBar(context, state.message,
                      duration: const Duration(milliseconds: 1600)));
            }
          }),
          builder: (context, state) {
            if (state is AddressLoaded) {
              return Column(
                children: [
                  state.addresses.isEmpty
                      ? SizedBox(
                          width: size.width,
                          height: size.height * 0.65,
                          child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Positioned(
                                  top: -100,
                                  right: 0,
                                  child: SvgPicture.asset(
                                    'assets/decorations/address-top-right.svg',
                                    width: 250,
                                  )),
                              Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: SvgPicture.asset(
                                      'assets/decorations/address-bottom-left.svg')),
                              Positioned(
                                  bottom: 30,
                                  right: 0,
                                  child: SvgPicture.asset(
                                    'assets/decorations/address-bottom-right.svg',
                                    width: 200,
                                  )),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: Constants.defaultPadding * 7),
                                child: Text(
                                  "Добавьте адрес для оформления\nдоставки Little Brazil",
                                  style: Constants.textTheme.headlineMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding:
                              EdgeInsets.only(bottom: Constants.defaultPadding),
                          child: ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: state.addresses.length,
                              itemBuilder: (context, index) => Dismissible(
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (direction) {
                                      context.read<AddressBloc>().add(
                                          AddressRemoved(
                                              phoneNumber: phoneNumber,
                                              address: state.addresses[index]));
                                    },
                                    key: ObjectKey(state.addresses[index]),
                                    background: Container(
                                      alignment: Alignment.centerRight,
                                      width: 60,
                                      color: Constants.errorColor,
                                      child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 20),
                                          width: 20,
                                          height: 20,
                                          child: SvgPicture.asset(
                                            'assets/icons/bin.svg',
                                            colorFilter: const ColorFilter.mode(
                                                Colors.white, BlendMode.srcIn),
                                          )),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Constants.defaultPadding),
                                      child: AddressListTile(
                                          address: state.addresses[index]),
                                    ),
                                  )),
                        ),
                ],
              );
            }
            return Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: Constants.defaultPadding),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Constants.defaultPadding * 0.75),
                  child: const ShimmerListTile(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
