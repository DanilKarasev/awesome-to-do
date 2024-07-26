part of 'sign_up_cubit.dart';

final class SignUpState extends Equatable {
  const SignUpState({
    this.email = '',
    this.password = '',
    this.obscurePassword = true,
    this.confirmedPassword = '',
    this.obscureConfirmedPassword = true,
    this.status = FormzSubmissionStatus.initial,
    this.enableValidation = false,
    this.errorMessage,
  });

  final String email;
  final String password;
  final bool obscurePassword;
  final String confirmedPassword;
  final bool obscureConfirmedPassword;
  final FormzSubmissionStatus status;
  final bool enableValidation;
  final String? errorMessage;

  bool get fieldsAreNotEmpty =>
      email.isNotEmpty && password.isNotEmpty && confirmedPassword.isNotEmpty;

  @override
  List<Object?> get props => [
        email,
        password,
        obscurePassword,
        confirmedPassword,
        obscureConfirmedPassword,
        status,
        enableValidation,
        errorMessage,
      ];

  SignUpState copyWith({
    String? email,
    String? password,
    bool? obscurePassword,
    String? confirmedPassword,
    bool? obscureConfirmedPassword,
    FormzSubmissionStatus? status,
    bool? enableValidation,
    String? errorMessage,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      obscureConfirmedPassword:
          obscureConfirmedPassword ?? this.obscureConfirmedPassword,
      status: status ?? this.status,
      enableValidation: enableValidation ?? this.enableValidation,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
