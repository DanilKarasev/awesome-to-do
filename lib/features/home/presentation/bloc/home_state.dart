part of 'home_cubit.dart';

final class HomeState extends Equatable {
  const HomeState({
    this.uncheckedTasks = const {},
    this.inProgressTasks = const {},
    this.doneTasks = const {},
    this.loadedUncheckedTasks = false,
    this.loadedInProgressTasks = false,
    this.loadedCompletedTasks = false,
  });

  final Map<String, TaskEntity> uncheckedTasks;
  final Map<String, TaskEntity> inProgressTasks;
  final Map<String, TaskEntity> doneTasks;

  final bool loadedUncheckedTasks;
  final bool loadedInProgressTasks;
  final bool loadedCompletedTasks;

  int get uncheckedCount => uncheckedTasks.length;
  int get doneCount => doneTasks.length;
  int get inProgressCount => inProgressTasks.length;

  List<TaskEntity> getListBasedOnStatus(TaskStatus status) {
    if (status.isDoing) {
      return inProgressTasks.values.toList();
    }
    if (status.isDone) {
      return doneTasks.values.toList();
    }
    return uncheckedTasks.values.toList();
  }

  bool getLoadingValueBasedOnStatus(TaskStatus status) {
    if (status.isDoing) {
      return loadedInProgressTasks;
    }
    if (status.isDone) {
      return loadedCompletedTasks;
    }
    return loadedUncheckedTasks;
  }

  @override
  List<Object> get props => [
        uncheckedTasks,
        inProgressTasks,
        doneTasks,
        loadedUncheckedTasks,
        loadedInProgressTasks,
        loadedCompletedTasks,
      ];

  HomeState copyWith({
    Map<String, TaskEntity>? uncheckedTasks,
    Map<String, TaskEntity>? inProgressTasks,
    Map<String, TaskEntity>? doneTasks,
    bool? loadedUncheckedTasks,
    bool? loadedInProgressTasks,
    bool? loadedCompletedTasks,
  }) {
    return HomeState(
      uncheckedTasks: uncheckedTasks ?? this.uncheckedTasks,
      inProgressTasks: inProgressTasks ?? this.inProgressTasks,
      doneTasks: doneTasks ?? this.doneTasks,
      loadedUncheckedTasks: loadedUncheckedTasks ?? this.loadedUncheckedTasks,
      loadedInProgressTasks:
          loadedInProgressTasks ?? this.loadedInProgressTasks,
      loadedCompletedTasks: loadedCompletedTasks ?? this.loadedCompletedTasks,
    );
  }
}
