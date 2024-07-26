part of 'login_cubit.dart';

final class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.obscurePassword = true,
    this.status = FormzSubmissionStatus.initial,
    this.enableValidation = false,
    this.errorMessage,
  });

  final String email;
  final String password;
  final bool obscurePassword;
  final FormzSubmissionStatus status;
  final bool enableValidation;
  final String? errorMessage;

  bool get fieldsAreNotEmpty => email.isNotEmpty && password.isNotEmpty;

  @override
  List<Object?> get props => [
        email,
        password,
        obscurePassword,
        status,
        enableValidation,
        errorMessage,
      ];

  LoginState copyWith({
    String? email,
    String? password,
    bool? obscurePassword,
    FormzSubmissionStatus? status,
    bool? enableValidation,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      status: status ?? this.status,
      enableValidation: enableValidation ?? this.enableValidation,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
