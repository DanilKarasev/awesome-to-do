import 'package:awesome_to_do/features/home/domain/entities/task_entity.dart';
import 'package:awesome_to_do/features/login/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskListItem extends StatelessWidget {
  final Function(TaskEntity task) onTap;
  final TaskEntity task;
  final UserEntity? creator;
  final UserEntity? requestor;

  const TaskListItem({
    super.key,
    required this.onTap,
    required this.task,
    this.creator,
    this.requestor,
  });

  Widget _subtitle() {
    final DateFormat format = DateFormat('dd/MM');
    final String due =
        task.dueDate != null ? format.format(task.dueDate!) : 'Not Set';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (task.shortDescription != null)
          Text(
            task.shortDescription!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        Row(
          children: [
            Expanded(
              child: Text(
                'Date Created: ${format.format(task.dateCreated)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Due Date: $due',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(task),
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              task.statusIcon.icon,
              color: task.statusIcon.color,
              size: 32,
            ),
          ],
        ),
        title: Text(task.title),
        tileColor: Colors.white,
        isThreeLine: true,
        subtitle: _subtitle(),
      ),
    );
  }
}
