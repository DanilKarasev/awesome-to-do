import 'package:awesome_to_do/core/utils/text_field_validators.dart';
import 'package:awesome_to_do/core/widgets/generic_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formz/formz.dart';

import '../../../../core/widgets/toast.dart';
import '../../../sign_up/presentation/pages/sign_up_page.dart';
import '../bloc/login_cubit.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          Toast.show(
            status: ToastStatus.error,
            message: state.errorMessage ?? 'Authentication Failure',
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: const Alignment(0, -1 / 3),
          child: SingleChildScrollView(
            child:
                BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
              return Form(
                key: context.read<LoginCubit>().formKey,
                autovalidateMode: state.enableValidation
                    ? AutovalidateMode.onUserInteraction
                    : null,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 240,
                    ),
                    const SizedBox(height: 16),
                    _EmailInput(),
                    const SizedBox(height: 8),
                    _PasswordInput(),
                    const SizedBox(height: 8),
                    _LoginButton(),
                    const SizedBox(height: 8),
                    _GoogleLoginButton(),
                    const SizedBox(height: 4),
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
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return GenericTextFormField(
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
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
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.password != current.password ||
          previous.obscurePassword != current.obscurePassword,
      builder: (context, state) {
        return GenericTextFormField(
          onChanged: (pwd) => context.read<LoginCubit>().passwordChanged(pwd),
          label: 'Password',
          obscureText: state.obscurePassword,
          onSuffixIconClick: context.read<LoginCubit>().toggleObscure,
          isRequired: true,
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                ),
                onPressed: state.fieldsAreNotEmpty
                    ? () => context.read<LoginCubit>().logInWithCredentials()
                    : null,
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              );
      },
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton.icon(
      key: const Key('loginForm_googleLogin_raisedButton'),
      label: const Text(
        'SIGN IN WITH GOOGLE',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.secondary,
      ),
      icon: const Icon(FontAwesomeIcons.google, color: Colors.white),
      onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      key: const Key('loginForm_createAccount_flatButton'),
      onPressed: () => Navigator.of(context).push<void>(SignUpPage.route()),
      child: Text(
        'CREATE ACCOUNT',
        style: TextStyle(color: theme.primaryColor),
      ),
    );
  }
}
