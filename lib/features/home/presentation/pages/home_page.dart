import 'package:awesome_to_do/features/create_or_update_task/presentation/pages/create_or_update_task_page.dart';
import 'package:awesome_to_do/features/home/presentation/bloc/home_cubit.dart';
import 'package:awesome_to_do/features/home/presentation/widgets/tasks_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/bloc/app_bloc.dart';
import '../../../../core/utils/alert.dart';
import '../widgets/avatar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final user = context.select((AppBloc bloc) => bloc.state.user);

    return BlocProvider(
      create: (_) => HomeCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.read<AppBloc>().appName),
        ),
        drawer: Drawer(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Avatar(photo: user.photo),
                const SizedBox(height: 4),
                Text(user.email ?? '', style: textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(user.name ?? '', style: textTheme.headlineSmall),
                ListTile(
                  dense: true,
                  title: const Text(
                    'Log Out',
                  ),
                  leading: const Icon(Icons.exit_to_app),
                  onTap: () async {
                    Alert.confirmationDialog(
                      context: context,
                      title: 'Logout',
                      body: 'Are you sure you want to logout?',
                      onPressPositive: () => context
                          .read<AppBloc>()
                          .add(const AppLogoutRequested()),
                    );
                  },
                ),
                const Spacer(),
                Text(
                  context.read<AppBloc>().appVersion,
                  style: const TextStyle(fontSize: 12.0),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        body: const TasksTabView(),
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
            onPressed: () => Navigator.of(context).push<void>(
              CreateOrUpdateTaskPage.route(),
            ),
            child: const Icon(Icons.add),
          );
        }),
      ),
    );
  }
}
