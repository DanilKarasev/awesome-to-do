import 'dart:async';
import 'dart:math';

import 'package:awesome_to_do/features/home/domain/repositories/tasks_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/failures.dart';
import '../../../../core/widgets/toast.dart';
import '../../../../injection.dart';
import '../../data/models/task_model.dart';
import '../../domain/entities/task_entity.dart';
import '../pages/task_details_bottomsheet.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState()) {
    _init();
  }
  final TasksRepository _tasksRepository = getIt<TasksRepository>();

  StreamSubscription<List<TaskEntity>>? _uncheckedTasksListener;
  StreamSubscription<List<TaskEntity>>? _inProgressTasksListener;
  StreamSubscription<List<TaskEntity>>? _completedTasksListener;

  final uuid = const Uuid();
  final Logger logger = Logger(printer: PrettyPrinter());

  /// Streams will be only guys who updating the UI
  /// Ideally - it should be cached and UI rebuild should happen immediately
  /// and independent from DB, and sync later
  void _init() async {
    await Future.wait([
      initUncheckedSnapshotListener(),
      initInProgressSnapshotListener(),
      initCompletedSnapshotListener(),
    ]);
  }

  Future<void> reFetchTasks({required TaskStatus listToFetch}) async {
    try {
      _setIsLoadedForList(listToFetch, false);
      await _tasksRepository.getTasksList(listToFetch);
      _setIsLoadedForList(listToFetch, true);
    } on FirestoreFailure catch (error, stackTrace) {
      _setIsLoadedForList(listToFetch, true);
      Toast.show(status: ToastStatus.error, message: error.message);
      logger.e(error.message, error: error, stackTrace: stackTrace);
    }
  }

  void _setIsLoadedForList(TaskStatus list, bool val) {
    switch (list) {
      case (TaskStatus.done):
        emit(state.copyWith(loadedCompletedTasks: val));
      case (TaskStatus.doing):
        emit(state.copyWith(loadedInProgressTasks: val));
      case (TaskStatus.unchecked):
      default:
        emit(state.copyWith(loadedUncheckedTasks: val));
    }
  }

  Future<void> initUncheckedSnapshotListener() async {
    try {
      _uncheckedTasksListener =
          _tasksRepository.getTasksStream(TaskStatus.unchecked).listen(
        (tasks) {
          final Map<String, TaskEntity> uncheckedTasks = {};
          for (var task in tasks) {
            uncheckedTasks[task.id] = task;
          }
          emit(state.copyWith(
            uncheckedTasks: uncheckedTasks,
            loadedUncheckedTasks: true,
          ));
        },
      );
    } on FirestoreFailure catch (error, stackTrace) {
      Toast.show(status: ToastStatus.error, message: error.message);
      logger.e(error.message, error: error, stackTrace: stackTrace);
    }
  }

  Future<void> initInProgressSnapshotListener() async {
    try {
      _inProgressTasksListener =
          _tasksRepository.getTasksStream(TaskStatus.doing).listen(
        (tasks) {
          final Map<String, TaskEntity> inProgressTasks = {};
          for (var task in tasks) {
            inProgressTasks[task.id] = task;
          }
          emit(state.copyWith(
            inProgressTasks: inProgressTasks,
            loadedInProgressTasks: true,
          ));
        },
      );
    } on FirestoreFailure catch (error, stackTrace) {
      Toast.show(status: ToastStatus.error, message: error.message);
      logger.e(error.message, error: error, stackTrace: stackTrace);
    }
  }

  Future<void> initCompletedSnapshotListener() async {
    try {
      _completedTasksListener =
          _tasksRepository.getTasksStream(TaskStatus.done).listen(
        (tasks) {
          final Map<String, TaskEntity> completedTasks = {};
          for (var task in tasks) {
            completedTasks[task.id] = task;
          }
          emit(state.copyWith(
            doneTasks: completedTasks,
            loadedCompletedTasks: true,
          ));
        },
      );
    } on FirestoreFailure catch (error, stackTrace) {
      Toast.show(status: ToastStatus.error, message: error.message);
      logger.e(error.message, error: error, stackTrace: stackTrace);
    }
  }

  Future<void> createNewTask(TaskEntity task) async {
    try {
      await _tasksRepository.createNew(task);
    } on FirestoreFailure catch (error, stackTrace) {
      Toast.show(status: ToastStatus.error, message: error.message);
      logger.e(error.message, error: error, stackTrace: stackTrace);
    }
  }

  void changeTaskStatus({
    required TaskEntity task,
    required TaskStatus newStatus,
  }) async {
    try {
      await _tasksRepository.moveToAnotherCollection(task, newStatus);
    } on FirestoreFailure catch (error, stackTrace) {
      Toast.show(status: ToastStatus.error, message: error.message);
      logger.e(error.message, error: error, stackTrace: stackTrace);
    }
    // Updating UI only
    // final TaskEntity updatedTask = task.copyWith(status: newStatus);
    //
    // final uncheckedTasks = {...state.uncheckedTasks};
    // final inProgressTasks = {...state.inProgressTasks};
    // final doneTasks = {...state.doneTasks};
    //
    // uncheckedTasks.remove(task.id);
    // inProgressTasks.remove(task.id);
    // doneTasks.remove(task.id);
    //
    // if (newStatus.isUnchecked) {
    //   uncheckedTasks[task.id] = updatedTask;
    // } else if (newStatus.isDoing) {
    //   inProgressTasks[task.id] = updatedTask;
    // } else if (newStatus.isDone) {
    //   doneTasks[task.id] = updatedTask;
    // }
    //
    // emit(state.copyWith(
    //   uncheckedTasks: uncheckedTasks,
    //   inProgressTasks: inProgressTasks,
    //   doneTasks: doneTasks,
    // ));
  }

  void discardTask(TaskEntity task) async {
    try {
      await _tasksRepository.deleteTask(task);
    } on FirestoreFailure catch (error, stackTrace) {
      Toast.show(status: ToastStatus.error, message: error.message);
      logger.e(error.message, error: error, stackTrace: stackTrace);
    }
    // Updating UI only
    // final uncheckedTasks = {...state.uncheckedTasks};
    // final inProgressTasks = {...state.inProgressTasks};
    // final doneTasks = {...state.doneTasks};
    //
    // uncheckedTasks.remove(task.id);
    // inProgressTasks.remove(task.id);
    // doneTasks.remove(task.id);
    // emit(state.copyWith(
    //   uncheckedTasks: uncheckedTasks,
    //   inProgressTasks: inProgressTasks,
    //   doneTasks: doneTasks,
    // ));
  }

  void openTaskDetails({
    required BuildContext context,
    required TaskEntity task,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return TaskDetailsBottomSheet(
          task: task,
          onStatusUpdate: (newStatus) => changeTaskStatus(
            task: task,
            newStatus: newStatus,
          ),
          onDiscard: (task) => discardTask(task),
        );
      },
    );
  }

  bool isEmptyList({required TaskStatus status}) {
    switch (status) {
      case TaskStatus.done:
        return state.doneTasks.isEmpty;
      case TaskStatus.doing:
        return state.inProgressTasks.isEmpty;
      case TaskStatus.unchecked:
      default:
        return state.uncheckedTasks.isEmpty;
    }
  }

  void addDummyTaskToDB() async {
    await _tasksRepository.createNew(TaskModel.dummy);
  }

  void addDummyTaskUI() {
    int rnd = Random().nextInt(3);
    TaskStatus status = TaskStatus.unchecked;
    if (rnd == 1) {
      status = TaskStatus.doing;
    } else if (rnd == 2) {
      status = TaskStatus.done;
    }

    final newTask = TaskEntity.dummy(status: status);
    final newTaskMap = {newTask.id: newTask};

    emit(state.copyWith(
      uncheckedTasks: status.isUnchecked
          ? {...state.uncheckedTasks, ...newTaskMap}
          : state.uncheckedTasks,
      inProgressTasks: status.isDoing
          ? {...state.inProgressTasks, ...newTaskMap}
          : state.inProgressTasks,
      doneTasks:
          status.isDone ? {...state.doneTasks, ...newTaskMap} : state.doneTasks,
    ));
  }

  @override
  Future<void> close() {
    _uncheckedTasksListener?.cancel();
    _inProgressTasksListener?.cancel();
    _completedTasksListener?.cancel();
    return super.close();
  }
}
