import 'package:awesome_to_do/core/widgets/toast.dart';
import 'package:awesome_to_do/features/create_or_update_task/presentation/bloc/create_or_update_task_cubit.dart';
import 'package:awesome_to_do/features/create_or_update_task/presentation/widgets/create_or_update_task_form.dart';
import 'package:awesome_to_do/features/home/domain/entities/task_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateOrUpdateTaskPage extends StatelessWidget {
  final TaskEntity? existingTask;
  const CreateOrUpdateTaskPage({
    super.key,
    this.existingTask,
  });

  static Route<void> route({TaskEntity? existingTask}) {
    return MaterialPageRoute<void>(
      builder: (_) => CreateOrUpdateTaskPage(existingTask: existingTask),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isCreate = existingTask == null;

    return BlocProvider(
      create: (_) => CreateOrUpdateTaskCubit(
        existingTask: existingTask,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isCreate ? 'Create New Task' : 'Update Task'),
        ),
        body: BlocListener<CreateOrUpdateTaskCubit, CreateOrUpdateTaskState>(
          listener: (context, state) {
            if (state.updatedSuccessfully) {
              Navigator.of(context).pop();
              Toast.show(
                status: ToastStatus.success,
                message: 'Task has been updated successfully!',
              );
            } else if (state.errorMessage != null) {
              Toast.show(
                status: ToastStatus.error,
                message: state.errorMessage!,
              );
            }
          },
          child: const CreateOrUpdateTaskForm(),
        ),
        bottomNavigationBar: _SaveButton(existingTask: existingTask),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final TaskEntity? existingTask;
  const _SaveButton({
    this.existingTask,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isCreate = existingTask == null;

    return BlocBuilder<CreateOrUpdateTaskCubit, CreateOrUpdateTaskState>(
      builder: (context, state) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: state.isLoading
                ? const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                    ),
                    onPressed: state.fieldsAreNotEmpty && !state.isLoading
                        ? isCreate
                            ? () => context
                                .read<CreateOrUpdateTaskCubit>()
                                .createTask()
                            : _hasChanges(existingTask!, state)
                                ? () => context
                                    .read<CreateOrUpdateTaskCubit>()
                                    .updateExistingTask(existingTask!)
                                : null
                        : null,
                    child: Text(
                      isCreate ? 'Create Task' : 'Update Task',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

bool _hasChanges(TaskEntity existingTask, CreateOrUpdateTaskState state) {
  return existingTask.title != state.title ||
      existingTask.shortDescription != state.shortDescription ||
      existingTask.description != state.description ||
      existingTask.dueDate != state.dueDate;
}
