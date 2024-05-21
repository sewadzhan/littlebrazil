import 'package:flutter/material.dart';
import 'package:littlebrazil/view/components/custom_text_input_field.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingCommentSection extends StatelessWidget {
  const BookingCommentSection({
    super.key,
    required this.commentsController,
  });

  final TextEditingController commentsController;

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: Constants.defaultPadding * 0.25),
          child: Text(appLocalization.additionalComment,
              style: Constants.headlineTextTheme.displaySmall!.copyWith(
                color: Constants.primaryColor,
              )),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: Constants.defaultPadding * 1.5),
          child: Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse potenti. Morbi volutpat, risus eu luctus maximus, arcu.",
              style: Constants.textTheme.bodyLarge!.copyWith()),
        ),
        CustomTextInputField(
          controller: commentsController,
          hintText: appLocalization.leaveYourCommentHere,
          maxLines: 5,
          titleText: appLocalization.comments,
        )
      ],
    );
  }
}
