import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../navigator/routes.dart';
import '../bloc/app_bloc.dart';

final Color bgColor = Colors.blueGrey.shade100;

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [
        Locale('en', ''), // English, no country code
      ],
      theme: ThemeData(
        scaffoldBackgroundColor: bgColor,
        appBarTheme: AppBarTheme(color: bgColor),
      ),
      darkTheme: ThemeData.dark(),
      home: FlowBuilder<AppStatus>(
        state: context.select((AppBloc bloc) => bloc.state.status),
        onGeneratePages: onGenerateAppViewPages,
      ),
    );
  }
}
