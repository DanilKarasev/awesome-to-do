import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recase/recase.dart';

import 'date_time_field.dart';

class GenericDatePicker extends StatelessWidget {
  final String? label;
  final String? hint;
  final IconData? icon;
  final TextInputType inputType;
  final bool isRequired;
  final bool obscureText;
  final bool enable;

  final DateTime? initialValue;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? errorInvalidText;

  final FocusNode? focusNode;
  final Function(DateTime?)? onFieldSubmitted;
  final Function(DateTime?)? onChanged;
  final TextStyle? labelTextStyle;
  final EdgeInsets? contentPadding;
  const GenericDatePicker({
    super.key,
    required this.label,
    this.obscureText = false,
    this.inputType = TextInputType.text,
    this.isRequired = false,
    this.icon,
    this.hint,
    this.enable = true,
    this.initialValue,
    this.firstDate,
    this.lastDate,
    this.focusNode,
    this.onFieldSubmitted,
    this.onChanged,
    this.errorInvalidText = 'Out of Range',
    this.labelTextStyle,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);
    final String locale = '${myLocale.languageCode}_${myLocale.countryCode}';
    final DateFormat dateFormat = DateFormat.yMd(locale);
    final TextEditingController textEditingController = TextEditingController(
        text: initialValue != null
            ? dateFormat.format(initialValue ?? DateTime.now())
            : '');

    return DateTimeField(
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      initialValue: initialValue,
      enabled: enable,
      format: dateFormat,
      controller: textEditingController,
      decoration: InputDecoration(
        label: label != null ? Text(label!.titleCase) : null,
        contentPadding: contentPadding ?? EdgeInsets.zero,
        hintText: hint,
        suffixIcon: icon != null
            ? Padding(
                padding: const EdgeInsets.all(0.0),
                child: Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                ),
              )
            : null,
      ),
      onShowPicker: (BuildContext context, DateTime? currentValue) {
        return showDatePicker(
            errorInvalidText: errorInvalidText,
            errorFormatText: 'Invalid date format',
            context: context,
            firstDate: firstDate ?? DateTime(1900),
            initialDate: initialValue ?? DateTime.now(),
            lastDate: lastDate ?? DateTime(3000),
            builder: (BuildContext context, Widget? child) {
              return child!;
            });
      },
      validator: (DateTime? value) {
        if (isRequired && value == null) {
          return 'This field is required';
        }
        return null;
      },
    );
  }
}
