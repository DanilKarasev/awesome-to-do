import 'package:awesome_to_do/features/home/domain/entities/task_entity.dart';
import 'package:awesome_to_do/features/home/domain/repositories/tasks_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/failures.dart';
import '../../../../injection.dart';

part 'create_or_update_task_state.dart';

class CreateOrUpdateTaskCubit extends Cubit<CreateOrUpdateTaskState> {
  CreateOrUpdateTaskCubit({
    TaskEntity? existingTask,
  }) : super(const CreateOrUpdateTaskState()) {
    _init(existingTask);
  }

  // CreateOrUpdateTaskCubit() : super(const CreateOrUpdateTaskState());
  final TasksRepository _tasksRepository = getIt<TasksRepository>();

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _loginFormKey;

  final uuid = const Uuid();
  final Logger logger = Logger(printer: PrettyPrinter());

  void _init(TaskEntity? existingTask) {
    if (existingTask != null) {
      emit(
        state.copyWith(
          title: existingTask.title,
          requestorId: existingTask.requestorId,
          dueDate: existingTask.dueDate,
          ownerId: existingTask.ownerId,
          description: existingTask.description ?? '',
          shortDescription: existingTask.shortDescription ?? '',
          status: existingTask.status,
        ),
      );
    }
  }

  void createTask() async {
    emit(state.copyWith(isLoading: true));
    try {
      await _tasksRepository.createNew(_taskEntityFromState());
      emit(state.copyWith(isLoading: false, updatedSuccessfully: true));
    } on FirestoreFailure catch (error, stackTrace) {
      emit(state.copyWith(isLoading: false, errorMessage: error.message));
      logger.e(error.message, error: error, stackTrace: stackTrace);
    }
  }

  void updateExistingTask(TaskEntity existingTask) async {
    emit(state.copyWith(isLoading: true));
    try {
      final TaskEntity newPayload = existingTask.copyWith(
        title: state.title,
        dueDate: state.dueDate,
        description: state.description,
        shortDescription: state.shortDescription,
      );
      await _tasksRepository.updateExisting(newPayload);
      emit(state.copyWith(isLoading: false, updatedSuccessfully: true));
    } on FirestoreFailure catch (error, stackTrace) {
      emit(state.copyWith(isLoading: false, errorMessage: error.message));
      logger.e(error.message, error: error, stackTrace: stackTrace);
    }
  }

  TaskEntity _taskEntityFromState() {
    return TaskEntity(
      id: const Uuid().v4(),
      requestorId: const Uuid().v4(),
      ownerId: const Uuid().v4(),
      title: state.title,
      dateCreated: DateTime.now(),
      dueDate: state.dueDate,
      description: state.description,
      shortDescription: state.shortDescription,
      status: state.status,
    );
  }

  void titleChange(String value) => emit(state.copyWith(title: value));

  void descriptionChange(String value) =>
      emit(state.copyWith(description: value));

  void shortDescriptionChange(String value) =>
      emit(state.copyWith(shortDescription: value));

  void statusChange(TaskStatus value) => emit(state.copyWith(status: value));

  void dueDateChange(DateTime value) => emit(state.copyWith(dueDate: value));
}
