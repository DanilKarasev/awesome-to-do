import 'package:awesome_to_do/core/widgets/generic_hold_to_perform_button.dart';
import 'package:awesome_to_do/core/widgets/generic_snackbar.dart';
import 'package:awesome_to_do/features/home/domain/entities/task_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskDetailsBottomSheet extends StatelessWidget {
  final TaskEntity task;
  final Function(TaskStatus newStatus) onStatusUpdate;
  final Function(TaskEntity task) onDiscard;

  const TaskDetailsBottomSheet({
    super.key,
    required this.task,
    required this.onStatusUpdate,
    required this.onDiscard,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat format = DateFormat('dd MMMM yyyy HH:mm');
    final theme = Theme.of(context);
    const btnTextStyle = TextStyle(color: Colors.white);

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          task.statusIcon.icon,
                          color: task.statusIcon.color,
                          size: 32,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          task.title,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => print('EDIT'),
                    icon: Icon(
                      Icons.edit,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
              if (task.shortDescription != null) ...[
                const SizedBox(height: 8),
                Text(
                  task.shortDescription!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              if (task.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  task.description!,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
              const SizedBox(height: 16),
              Text('Date Created: ${format.format(task.dateCreated)}'),
              if (task.dueDate != null) ...[
                const SizedBox(height: 8),
                Text('Due Date: ${format.format(task.dueDate!)}'),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      if (task.isUnchecked) ...[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TaskStatus.doing.color,
                          ),
                          onPressed: () {
                            onStatusUpdate(TaskStatus.doing);
                            showSnackBar(
                              context,
                              label: 'You started to work on this task',
                            );
                            Navigator.of(context).maybePop();
                          },
                          child: const Text(
                            "Start Working",
                            style: btnTextStyle,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (task.isDoing)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TaskStatus.done.color,
                          ),
                          onPressed: () {
                            onStatusUpdate(TaskStatus.done);
                            showSnackBar(
                              context,
                              label: "You've completed this task!",
                            );
                            Navigator.of(context).maybePop();
                          },
                          child: const Text(
                            "Complete",
                            style: btnTextStyle,
                          ),
                        ),
                      if (task.isDone)
                        Row(
                          children: [
                            Icon(
                              size: 32,
                              TaskStatus.done.iconData,
                              color: TaskStatus.done.color,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              "Completed!",
                              style: TextStyle(
                                color: TaskStatus.done.color,
                                fontSize: 24,
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                ],
              ),
              if (task.isUnchecked) ...[
                const SizedBox(height: 8),
                Center(
                  child: GenericHoldToPerformButton(
                    label: 'Hold to Discard',
                    onConfirm: () {
                      onDiscard(task);
                      showSnackBar(
                        context,
                        label: 'Task deleted!',
                      );
                      Navigator.of(context).maybePop();
                    },
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
