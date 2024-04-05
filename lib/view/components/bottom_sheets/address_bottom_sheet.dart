import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littlebrazil/logic/blocs/address/address_bloc.dart';
import 'package:littlebrazil/logic/blocs/checkout/checkout_bloc.dart';
import 'package:littlebrazil/view/components/custom_outlined_button.dart';
import 'package:littlebrazil/view/components/list_tiles/address_list_tile.dart';
import 'package:littlebrazil/view/components/shimmer_widgets/shimmer_list_tile.dart';
import 'package:littlebrazil/view/config/constants.dart';

//Address bottom sheet for chossing delivey address in Checkout Screen
class AddressBottomSheet extends StatelessWidget {
  const AddressBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        SafeArea(
          child: Container(
              padding: EdgeInsets.only(
                  top: Constants.defaultPadding * 2,
                  left: Constants.defaultPadding,
                  right: Constants.defaultPadding,
                  bottom: Constants.defaultPadding),
              child: BlocBuilder<AddressBloc, AddressState>(
                builder: (context, state) {
                  if (state is AddressLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: Constants.defaultPadding * 0.5),
                          child: Text("Укажите адрес доставки",
                              style: Constants.headlineTextTheme.displayMedium!
                                  .copyWith(
                                color: Constants.primaryColor,
                              )),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: Constants.defaultPadding),
                          child: MediaQuery.removePadding(
                            context: context,
                            removeBottom: true,
                            child: ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: state.addresses.length,
                                itemBuilder: (context1, index) =>
                                    AddressListTile(
                                        function: () {
                                          context.read<CheckoutBloc>().add(
                                              CheckoutAddressChanged(
                                                  state.addresses[index]));
                                          Navigator.pop(context);
                                        },
                                        address: state.addresses[index])),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: Constants.defaultPadding * 0.3),
                          child: CustomOutlinedButton(
                              text: "ДОБАВИТЬ АДРЕС",
                              function: () {
                                Navigator.pushNamed(context, '/addAddress');
                              }),
                        )
                      ],
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Constants.defaultPadding),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 3,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Constants.defaultPadding * 0.75),
                        child: const ShimmerListTile(),
                      ),
                    ),
                  );
                },
              )),
        ),
      ],
    );
  }
}
