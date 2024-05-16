import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:littlebrazil/view/config/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum Picker { none, date, time }

class CustomTextInputField extends StatelessWidget {
  const CustomTextInputField(
      {super.key,
      this.titleText = "",
      required this.hintText,
      this.controller,
      this.keyboardType = TextInputType.text,
      this.pickerType = Picker.none,
      this.onlyRead = false,
      this.maxLines = 1,
      this.inputFormatters,
      this.onTap});

  final String? titleText;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final Picker pickerType;
  final bool onlyRead;
  final int maxLines;
  final Function? onTap;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    return TextFormField(
      controller: controller,
      onTap: () async {
        if (controller == null) {
          return;
        }
        if (pickerType == Picker.date) {
          DateTime? date = await showDatePicker(
            //locale: const Locale("ru", "RU"),
            cancelText: appLocalization.cancel,
            confirmText: appLocalization.select,
            context: context,
            initialDate: controller!.text.isEmpty
                ? DateTime.now()
                : DateFormat('dd.MM.yyyy').parse(controller!.text),
            firstDate: DateTime(1925),
            lastDate: DateTime(2025),
          );
          if (date != null) {
            controller!.text = DateFormat('dd.MM.yyyy').format(date);
          }
        } else if (pickerType == Picker.time) {
          final TimeOfDay? timeOfDay = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
              initialEntryMode: TimePickerEntryMode.dial,
              builder: (context, childWidget) {
                return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(alwaysUse24HourFormat: true),
                    child: childWidget!);
              });

          if (timeOfDay != null && context.mounted) {
            controller!.text = timeOfDay.format(context);
          }
        }
        if (onTap != null) {
          onTap!();
        }
      },
      readOnly: onlyRead || pickerType != Picker.none,
      keyboardType: keyboardType,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      style: maxLines == 1
          ? Constants.textTheme.bodyLarge
          : Constants.textTheme.bodyMedium,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              horizontal: Constants.defaultPadding * 0.75,
              vertical: Constants.defaultPadding),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          label: maxLines > 1 && titleText != null
              ? Text(
                  titleText!,
                  style: Constants.textTheme.bodyLarge!
                      .copyWith(color: Constants.darkGrayColor),
                )
              : null,
          hintText: hintText,
          hintStyle: Constants.textTheme.bodyLarge!
              .copyWith(color: Constants.textInputColor),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
            width: 1,
            color: Constants.thirdPrimaryColor,
          )),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
            width: 1,
            color: Constants.textInputColor,
          ))),
    );
  }
}
