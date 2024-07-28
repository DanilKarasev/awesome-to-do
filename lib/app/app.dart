import 'package:awesome_to_do/app/view/app_view.dart';
import 'package:awesome_to_do/features/login/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../injection.dart';
import 'bloc/app_bloc.dart';

/// The Widget that configures your application.
class ToDoApp extends StatelessWidget {
  const ToDoApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppBloc(
        authRepository: getIt<AuthRepository>(),
      )..init(),
      child: const AppView(),
    );
  }
}
