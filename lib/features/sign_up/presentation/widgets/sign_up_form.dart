import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../../core/utils/text_field_validators.dart';
import '../../../../core/widgets/generic_text_form_field.dart';
import '../../../../core/widgets/toast.dart';
import '../../bloc/sign_up_cubit.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          Navigator.of(context).pop();
        } else if (state.status.isFailure) {
          Toast.show(
              status: ToastStatus.error,
              message: state.errorMessage ?? 'Sign Up Failure');
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: const Alignment(0, -1 / 3),
          child: SingleChildScrollView(
            child: BlocBuilder<SignUpCubit, SignUpState>(
                builder: (context, state) {
              return Form(
                key: context.read<SignUpCubit>().formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _EmailInput(),
                    const SizedBox(height: 8),
                    _PasswordInput(),
                    const SizedBox(height: 8),
                    _ConfirmPasswordInput(),
                    const SizedBox(height: 8),
                    _SignUpButton(),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return GenericTextFormField(
          onChanged: (email) => context.read<SignUpCubit>().emailChanged(email),
          label: 'Email',
          inputType: TextInputType.emailAddress,
          validators: [emailValidator],
          isRequired: true,
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.obscurePassword != current.obscurePassword,
      builder: (context, state) {
        return GenericTextFormField(
          onChanged: (val) => context.read<SignUpCubit>().passwordChanged(val),
          label: 'Password',
          obscureText: state.obscurePassword,
          onSuffixIconClick: context.read<SignUpCubit>().togglePwdObscure,
          validators: [
            minLengthValidator(8),
            containsCharacterValidator,
            containsLowercaseValidator,
            containsUppercaseValidator,
            containsNumericValidator,
            notContainWhiteSpace,
          ],
          isRequired: true,
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.confirmedPassword != current.confirmedPassword ||
          previous.obscureConfirmedPassword != current.obscureConfirmedPassword,
      builder: (context, state) {
        return GenericTextFormField(
          onChanged: (val) =>
              context.read<SignUpCubit>().confirmedPasswordChanged(val),
          label: 'Confirm Password',
          obscureText: state.obscureConfirmedPassword,
          onSuffixIconClick:
              context.read<SignUpCubit>().toggleConfirmPwdObscure,
          validators: [
            matchesExactValue(
              state.password,
              errorMessage: 'Passwords do not match',
            ),
          ],
          isRequired: true,
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('signUpForm_continue_raisedButton'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                ),
                onPressed: state.fieldsAreNotEmpty
                    ? () => context.read<SignUpCubit>().signUpFormSubmitted()
                    : null,
                child: const Text(
                  'SIGN UP',
                  style: TextStyle(color: Colors.white),
                ),
              );
      },
    );
  }
}
