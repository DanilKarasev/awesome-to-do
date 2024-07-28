import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../injection.dart';
import '../../../login/domain/repositories/auth_repository.dart';
import '../../domain/entities/task_entity.dart';
import '../pages/task_details_bottomsheet.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());
  final AuthRepository _authRepository = getIt<AuthRepository>();

  void init() async {}

  Future<void> fetchTasks({required TaskStatus listToFetch}) async {
    // TODO Fetch from DB and refresh UI
  }

  void changeTaskStatus({
    required TaskEntity task,
    required TaskStatus newStatus,
  }) async {
    // Update UI and sync DB simultaneously
    final TaskEntity updatedTask = task.copyWith(status: newStatus);

    final uncheckedTasks = {...state.uncheckedTasks};
    final inProgressTasks = {...state.inProgressTasks};
    final doneTasks = {...state.doneTasks};

    uncheckedTasks.remove(task.id);
    inProgressTasks.remove(task.id);
    doneTasks.remove(task.id);

    if (newStatus.isUnchecked) {
      uncheckedTasks[task.id] = updatedTask;
    } else if (newStatus.isDoing) {
      inProgressTasks[task.id] = updatedTask;
    } else if (newStatus.isDone) {
      doneTasks[task.id] = updatedTask;
    }

    emit(state.copyWith(
      allTasks: {...state.allTasks, task.id: updatedTask},
      uncheckedTasks: uncheckedTasks,
      inProgressTasks: inProgressTasks,
      doneTasks: doneTasks,
    ));

    //TODO Call DB update task
    await Future.delayed(Durations.medium2);
  }

  void discardTask(TaskEntity task) async {
    final allTasks = {...state.allTasks};
    final uncheckedTasks = {...state.uncheckedTasks};
    final inProgressTasks = {...state.inProgressTasks};
    final doneTasks = {...state.doneTasks};

    allTasks.remove(task.id);
    uncheckedTasks.remove(task.id);
    inProgressTasks.remove(task.id);
    doneTasks.remove(task.id);
    emit(state.copyWith(
      allTasks: allTasks,
      uncheckedTasks: uncheckedTasks,
      inProgressTasks: inProgressTasks,
      doneTasks: doneTasks,
    ));

    //TODO Call DB update task
    await Future.delayed(Durations.medium2);
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

  void addDummyTask() {
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
      allTasks: {...state.allTasks, ...newTaskMap},
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
}
