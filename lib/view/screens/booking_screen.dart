import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:littlebrazil/logic/cubits/booking/booking_cubit.dart';
import 'package:littlebrazil/view/components/booking_screen/booking_comment_section.dart';
import 'package:littlebrazil/view/components/booking_screen/booking_confirm_section.dart';
import 'package:littlebrazil/view/components/booking_screen/booking_date_time_section.dart';
import 'package:littlebrazil/view/components/custom_elevated_button.dart';
import 'package:littlebrazil/view/components/custom_outlined_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:littlebrazil/view/config/constants.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int currentStep = 0;

  final TextEditingController commentsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: TextButton(
          style: TextButton.styleFrom(
            shape: const CircleBorder(),
          ),
          child: SizedBox(
            width: 25,
            child: SvgPicture.asset(
              currentStep == 0
                  ? 'assets/icons/cross.svg'
                  : 'assets/icons/arrow-left.svg',
            ),
          ),
          onPressed: () {
            if (currentStep == 0) {
              Navigator.pop(context);
              return;
            }
            setState(
              () => currentStep -= 1,
            );
          },
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: Constants.defaultPadding),
                  child: Text(
                    appLocalization.reservation,
                    style: Constants.headlineTextTheme.displayLarge!
                        .copyWith(color: Constants.primaryColor),
                  ),
                ),
              ],
            )),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
            padding: EdgeInsets.all(Constants.defaultPadding),
            decoration: const BoxDecoration(
                color: Constants.backgroundColor,
                border: Border(
                    top:
                        BorderSide(color: Constants.lightGrayColor, width: 1))),
            child: currentStep != getSteps().length - 1
                ? CustomOutlinedButton(
                    text: appLocalization.next,
                    function: () {
                      if (currentStep == 0 &&
                          !context.read<BookingCubit>().validateFields()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            Constants.errorSnackBar(context,
                                appLocalization.fillAllRequiredFields));
                        return;
                      }
                      setState(() {
                        currentStep = currentStep + 1;
                      });
                    })
                : BlocConsumer<BookingCubit, BookingState>(
                    listener: (context, state) {
                      if (state is BookingErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            Constants.errorSnackBar(
                                context, appLocalization.unexpectedError,
                                duration: const Duration(milliseconds: 500)));
                      } else if (state is BookingSuccessDelivery) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                            Constants.successSnackBar(
                                context, appLocalization.reservationRequestSent,
                                duration: const Duration(milliseconds: 1500)));
                      }
                    },
                    builder: (context, state) {
                      return CustomElevatedButton(
                          isLoading: state is BookingLoadingState,
                          text: appLocalization.confirm,
                          function: () {
                            context
                                .read<BookingCubit>()
                                .sendBooking(comments: commentsController.text);
                          });
                    },
                  )),
      ),
      body: SafeArea(
          child: Theme(
        data: ThemeData(
          canvasColor: Constants.backgroundColor,
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Constants.secondPrimaryColor,
              ),
        ),
        child: Stepper(
          type: StepperType.horizontal,
          currentStep: currentStep,
          elevation: 0,
          steps: getSteps(),
          controlsBuilder: (context, controller) {
            return const SizedBox.shrink();
          },
          onStepTapped: (value) {
            if (value < currentStep) {
              setState(() {
                currentStep = value;
              });
            }
          },
        ),
      )),
    );
  }

  List<Step> getSteps() {
    return [
      Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: const SizedBox.shrink(),
          content: const BookingDateTimeSection()),
      Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: const SizedBox.shrink(),
          content:
              BookingCommentSection(commentsController: commentsController)),
      Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: const SizedBox.shrink(),
          content: BookingConfirmSection(
            comments: commentsController.text,
          )),
    ];
  }
}
