import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:littlebrazil/data/models/restaurant_user.dart';
import 'package:littlebrazil/logic/blocs/current_user/current_user_bloc.dart';
import 'package:littlebrazil/logic/blocs/edit_user/edit_user_bloc.dart';
import 'package:littlebrazil/view/components/custom_elevated_button.dart';
import 'package:littlebrazil/view/components/custom_text_input_field.dart';
import 'package:littlebrazil/view/components/sliver_body.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    final CurrentUserState currentUserState =
        context.read<CurrentUserBloc>().state;
    RestaurantUser? currentUser =
        currentUserState is CurrentUserRetrieveSuccessful
            ? currentUserState.user
            : null;
    TextEditingController nameController =
        TextEditingController(text: currentUser!.name);
    TextEditingController emailController =
        TextEditingController(text: currentUser.email);
    TextEditingController birthdayController =
        TextEditingController(text: currentUser.birthday);
    TextEditingController phoneController =
        TextEditingController(text: currentUser.phoneNumber);

    return BlocListener<EditUserBloc, EditUserState>(
      listener: (context, state) {
        if (state is UserEditFailure) {
          ScaffoldMessenger.of(context).showSnackBar(Constants.errorSnackBar(
            context,
            state.message,
          ));
        } else if (state is UserEditSuccessful) {
          context.read<CurrentUserBloc>().add(CurrentUserSet(state.user));
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(Constants.successSnackBar(
              context, appLocalization.dataEditedSuccessfully,
              duration: const Duration(milliseconds: 1600)));
        }
      },
      child: SliverBody(
          title: appLocalization.myProfile,
          actions: [
            PopupMenuButton(
              onSelected: (value) {
                if (value == "deleteAccount") {
                  Navigator.pushNamed(context, '/deleteAccount');
                }
              },
              icon: SizedBox(
                width: 25,
                child: SvgPicture.asset('assets/icons/dots.svg',
                    colorFilter: const ColorFilter.mode(
                        Constants.darkGrayColor, BlendMode.srcIn)),
              ),
              padding: EdgeInsets.zero,
              itemBuilder: (BuildContext context1) {
                return [
                  PopupMenuItem<String>(
                    value: "deleteAccount",
                    child: Text(
                      appLocalization.deleteAccount,
                      style: Constants.textTheme.bodyLarge,
                    ),
                  )
                ];
              },
            )
          ],
          bottomBar: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                  color: Constants.backgroundColor,
                  border: Border(
                      top: BorderSide(
                          color: Constants.lightGrayColor, width: 1))),
              padding: EdgeInsets.all(Constants.defaultPadding),
              child: BlocBuilder<CurrentUserBloc, CurrentUserState>(
                  builder: (context, state) {
                if (state is CurrentUserRetrieveSuccessful) {
                  return CustomElevatedButton(
                      text: appLocalization.save,
                      function: () {
                        context.read<EditUserBloc>().add(UserEdited(
                                phoneNumber: state.user.phoneNumber,
                                oldData: {
                                  "phoneNumber": state.user.phoneNumber,
                                  "name": state.user.name,
                                  "email": state.user.email,
                                  "birthday": state.user.birthday
                                },
                                newData: {
                                  "phoneNumber": state.user.phoneNumber,
                                  "name": nameController.text,
                                  "email": emailController.text,
                                  "birthday": birthdayController.text
                                }));
                      });
                }
                return const SizedBox.shrink();
              }),
            ),
          ),
          child: Padding(
              padding: EdgeInsets.only(
                left: Constants.defaultPadding,
                right: Constants.defaultPadding,
                top: Constants.defaultPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: Constants.defaultPadding),
                    child: CustomTextInputField(
                      controller: phoneController,
                      titleText: appLocalization.phoneNumber,
                      hintText: "Номер телефона",
                      keyboardType: TextInputType.text,
                      onlyRead: true,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: Constants.defaultPadding),
                    child: CustomTextInputField(
                      controller: nameController,
                      titleText: appLocalization.name,
                      hintText: appLocalization.mark,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: Constants.defaultPadding),
                    child: CustomTextInputField(
                      controller: emailController,
                      hintText: appLocalization.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: Constants.defaultPadding),
                    child: CustomTextInputField(
                      controller: birthdayController,
                      hintText: appLocalization.birthday,
                      pickerType: Picker.date,
                    ),
                  ),
                ],
              ))),
    );
  }
}
