import 'package:equatable/equatable.dart';
import 'package:recase/recase.dart';

import '../constants/string_constants.dart';

class TextFieldValidatorEntity extends Equatable {
  final bool Function(String) isValid;
  final String message;
  const TextFieldValidatorEntity({
    required this.isValid,
    required this.message,
  });
  @override
  List<Object?> get props => [
        isValid,
        message,
      ];
}

TextFieldValidatorEntity nameValidator = TextFieldValidatorEntity(
    isValid: (String val) => RegExp(r"^[a-zA-Z.\-'\s]+$").hasMatch(val),
    message: 'Please enter a valid name');

TextFieldValidatorEntity phoneValidator = TextFieldValidatorEntity(
    isValid: (String val) => RegExp(r'^[0-9\s().+-]+$').hasMatch(val),
    message: 'Please enter a valid phone number');

TextFieldValidatorEntity minLengthValidator(int length) =>
    TextFieldValidatorEntity(
        isValid: (String val) => val.length >= length,
        message: 'Minimum length is $length characters');

TextFieldValidatorEntity maxLengthValidator(int length) =>
    TextFieldValidatorEntity(
        isValid: (String val) => val.length <= length,
        message: 'Maximum length is $length characters');

TextFieldValidatorEntity containsLowercaseValidator = TextFieldValidatorEntity(
  isValid: (String val) => val.contains(RegExp(r'[a-z]')),
  message: msgNeedsLowerCase,
);

TextFieldValidatorEntity containsUppercaseValidator = TextFieldValidatorEntity(
  isValid: (String val) => val.contains(RegExp(r'[A-Z]')),
  message: msgNeedsUpperCase,
);

TextFieldValidatorEntity containsNumericValidator = TextFieldValidatorEntity(
  isValid: (String val) => val.contains(RegExp(r'[0-9]')),
  message: msgNeedsNumeric,
);

TextFieldValidatorEntity containsCharacterValidator = TextFieldValidatorEntity(
  isValid: (String val) => val.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
  message: msgNeedsSpecialChar,
);

TextFieldValidatorEntity notContainWhiteSpace = TextFieldValidatorEntity(
    isValid: (String val) => !val.contains(' '),
    message: 'Your password can’t contain a blank space');

TextFieldValidatorEntity notTheSameWith(
  String? value, {
  required String newValueLabel,
  required String couldNotMatchLabel,
}) =>
    TextFieldValidatorEntity(
        isValid: (String val) => val != value,
        message:
            '${newValueLabel.sentenceCase} could not be the same as $couldNotMatchLabel');

TextFieldValidatorEntity matchesExactValue(
  String? value, {
  required String errorMessage,
}) =>
    TextFieldValidatorEntity(
      isValid: (String val) => val == value,
      message: errorMessage,
    );

TextFieldValidatorEntity numericValidator = TextFieldValidatorEntity(
  isValid: (String val) => RegExp(r'^\d*\.?\d+$').hasMatch(val),
  message: 'Please enter a valid number',
);

TextFieldValidatorEntity emailValidator = TextFieldValidatorEntity(
  isValid: (String val) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(val);
  },
  message: 'Please enter a valid email address',
);
