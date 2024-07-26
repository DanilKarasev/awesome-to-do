import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';

import '../../../core/failures.dart';
import '../../../injection.dart';
import '../../login/domain/repositories/auth_repository.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(const SignUpState());

  final AuthRepository _authRepository = getIt<AuthRepository>();

  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _signUpFormKey;

  void emailChanged(String value) {
    emit(state.copyWith(email: value));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value));
  }

  void confirmedPasswordChanged(String value) {
    emit(state.copyWith(confirmedPassword: value));
  }

  void togglePwdObscure() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void toggleConfirmPwdObscure() {
    emit(state.copyWith(
        obscureConfirmedPassword: !state.obscureConfirmedPassword));
  }

  Future<void> signUpFormSubmitted() async {
    final bool isFormValid = _signUpFormKey.currentState!.validate();

    if (isFormValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        await _authRepository.signUp(
          email: state.email,
          password: state.password,
        );
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } on SignUpWithEmailAndPasswordFailure catch (e) {
        emit(
          state.copyWith(
            errorMessage: e.message,
            status: FormzSubmissionStatus.failure,
          ),
        );
      } catch (_) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
    emit(state.copyWith(enableValidation: true));
  }
}
