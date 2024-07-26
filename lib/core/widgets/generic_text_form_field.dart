import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/text_field_validators.dart';

class GenericTextFormField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? editingController;
  final bool enabled, readOnly;
  final FocusNode? focusNode;
  final bool obscureText;
  final List<TextFieldValidatorEntity>? validators;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function(bool)? onFocusChange;
  final Function()? onSuffixIconClick;
  final bool isRequired;
  final TextInputType inputType;
  final String? errorText;
  final AutovalidateMode autoValidateMode;
  final TextInputAction? textInputAction;
  final TextStyle? labelTextStyle;
  final Function()? onEditingComplete;
  final Function()? onTap;
  final EdgeInsetsGeometry contentPadding;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final IconData? suffixIcon;
  final TextStyle? textStyle;
  final TextStyle? errorStyle;
  final IconData? prefixIcon;
  const GenericTextFormField(
      {super.key,
      required this.label,
      this.hint,
      this.editingController,
      this.inputType = TextInputType.text,
      this.enabled = true,
      this.focusNode,
      this.validators,
      this.onChanged,
      this.inputFormatters,
      this.onSubmitted,
      this.onFocusChange,
      this.onSuffixIconClick,
      this.textCapitalization = TextCapitalization.sentences,
      this.errorText,
      this.isRequired = false,
      this.obscureText = false,
      this.autoValidateMode = AutovalidateMode.disabled,
      this.textInputAction,
      this.onTap,
      this.onEditingComplete,
      this.labelTextStyle,
      this.contentPadding =
          const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      this.suffixIcon,
      this.readOnly = false,
      this.textStyle,
      this.errorStyle,
      this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FocusScope(
          onFocusChange: onFocusChange,
          child: TextFormField(
            style: textStyle,
            inputFormatters: inputFormatters,
            textCapitalization: inputType == TextInputType.text
                ? textCapitalization
                : TextCapitalization.none,
            onEditingComplete: onEditingComplete,
            textInputAction: textInputAction,
            autovalidateMode: autoValidateMode,
            controller: editingController,
            enabled: enabled,
            onTap: onTap,
            obscureText: obscureText,
            validator: (String? value) {
              if (isRequired && value?.trim() == '') {
                return 'This fields is required';
              }
              if (validators != null && value != null && value.trim() != '') {
                for (var validator in validators!) {
                  if (!validator.isValid(value.trim())) {
                    return validator.message;
                  }
                }
              }
              if (inputType == TextInputType.visiblePassword) {
                if (value == '' && isRequired) {
                  return null;
                } else if (value!.length < 8) {
                  return 'Invalid Password';
                }
              }
              return null;
            },
            onChanged: onChanged,
            onFieldSubmitted: onSubmitted,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 10),
              alignLabelWithHint: true,
              label: Text(label),
              errorText: errorText,
              errorStyle: errorStyle,
              contentPadding: contentPadding,
              labelStyle: labelTextStyle,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor, width: 0.8),
              ),
              prefix: prefixIcon != null ? Icon(prefixIcon) : null,
              suffix: onSuffixIconClick != null
                  ? GestureDetector(
                      onTap: onSuffixIconClick,
                      child: Icon(
                        suffixIcon ??
                            (obscureText
                                ? Icons.visibility
                                : Icons.visibility_off),
                        color: readOnly
                            ? Theme.of(context).disabledColor
                            : Theme.of(context).primaryColor,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
