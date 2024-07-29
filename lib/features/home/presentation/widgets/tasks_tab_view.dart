import 'package:awesome_to_do/core/constants/color_constants.dart';
import 'package:awesome_to_do/core/utils/string_extensons.dart';
import 'package:awesome_to_do/features/home/domain/entities/task_entity.dart';
import 'package:awesome_to_do/features/home/presentation/bloc/home_cubit.dart';
import 'package:awesome_to_do/features/home/presentation/widgets/tasks_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TasksTabView extends StatefulWidget {
  const TasksTabView({super.key});

  @override
  State<StatefulWidget> createState() => _SignQueueTabBarState();
}

class _SignQueueTabBarState extends State<TasksTabView>
    with SingleTickerProviderStateMixin {
  final List<TaskStatus> tabs = TaskStatus.values;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HomeCubit cubit = context.read<HomeCubit>();
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Material(
                elevation: 2,
                color: Colors.white,
                child: BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                  return TabBar(
                    controller: tabController,
                    tabs: <Tab>[
                      for (TaskStatus tab in tabs)
                        _tabBuilder(
                          tab,
                          uncheckedCount: state.uncheckedCount,
                          doneCount: state.doneCount,
                          doingCount: state.inProgressCount,
                        ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
        Expanded(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return TabBarView(
                controller: tabController,
                children: [
                  for (var tab in tabs)
                    TasksList(
                      taskList: state.getListBasedOnStatus(tab),
                      tabName: tab.name,
                      isLoaded: state.getLoadingValueBasedOnStatus(tab),
                      onTap: (TaskEntity task) => cubit.openTaskDetails(
                        context: context,
                        task: task,
                      ),
                      onRefresh: () => cubit.reFetchTasks(
                        listToFetch: tab,
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

Tab _tabBuilder(
  TaskStatus status, {
  required int uncheckedCount,
  required int doingCount,
  required int doneCount,
}) {
  final String tabTitle = status.lbl.capitalize();
  int itemsCount = uncheckedCount;
  if (status.isDone) {
    itemsCount = doneCount;
  }
  if (status.isDoing) {
    itemsCount = doingCount;
  }
  return Tab(
    child: FittedBox(
      fit: BoxFit.fitWidth,
      child: itemsCount > 0
          ? Badge.count(
              offset: const Offset(12, -12),
              alignment: Alignment.topRight,
              count: itemsCount,
              backgroundColor: status.isUnchecked
                  ? null
                  : status.isDone
                      ? successColor
                      : alertColor,
              child: Text(tabTitle),
            )
          : Text(tabTitle),
    ),
  );
}
