import 'package:awesome_to_do/core/utils/string_extensons.dart';
import 'package:awesome_to_do/features/home/presentation/widgets/task_list_item.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/task_entity.dart';
import 'empty_state.dart';

class TasksList extends StatelessWidget {
  final String tabName;
  final List<TaskEntity> taskList;
  final Function(TaskEntity task) onTap;
  final RefreshCallback onRefresh;

  const TasksList({
    super.key,
    required this.taskList,
    required this.tabName,
    required this.onTap,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: taskList.isEmpty
          ? TaskListEmptyState(
              text: 'There are no ${tabName.capitalize()} items',
            )
          : ListView.separated(
              itemBuilder: (_, int index) => TaskListItem(
                onTap: (TaskEntity task) => onTap(task),
                task: taskList[index],
              ),
              separatorBuilder: (context, _) {
                return const Divider(
                  thickness: 1,
                  height: 1,
                );
              },
              itemCount: taskList.length,
            ),
    );
  }
}
