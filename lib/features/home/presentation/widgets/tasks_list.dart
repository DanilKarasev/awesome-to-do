import 'package:awesome_to_do/core/utils/string_extensons.dart';
import 'package:awesome_to_do/features/home/presentation/widgets/task_item_shimmer.dart';
import 'package:awesome_to_do/features/home/presentation/widgets/task_list_item.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/task_entity.dart';
import 'empty_state.dart';

class TasksList extends StatelessWidget {
  final String tabName;
  final List<TaskEntity> taskList;
  final Function(TaskEntity task) onTap;
  final RefreshCallback onRefresh;
  final bool isLoaded;

  const TasksList({
    super.key,
    required this.taskList,
    required this.tabName,
    required this.onTap,
    required this.onRefresh,
    required this.isLoaded,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: taskList.isEmpty && isLoaded
          ? TaskListEmptyState(
              text: 'There are no ${tabName.capitalize()} items',
            )
          : ListView.separated(
              physics: isLoaded ? null : const NeverScrollableScrollPhysics(),
              itemBuilder: (_, int index) => isLoaded
                  ? TaskListItem(
                      onTap: (TaskEntity task) => onTap(task),
                      task: taskList[index],
                    )
                  : const TaskItemShimmer(),
              separatorBuilder: (context, _) {
                return const Divider(
                  thickness: 1,
                  height: 1,
                );
              },
              itemCount: isLoaded ? taskList.length : 30,
            ),
    );
  }
}
