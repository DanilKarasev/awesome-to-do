part of 'home_cubit.dart';

final class HomeState extends Equatable {
  const HomeState({
    this.allTasks = const {},
    this.uncheckedTasks = const {},
    this.inProgressTasks = const {},
    this.doneTasks = const {},
  });

  final Map<String, TaskEntity> allTasks;
  final Map<String, TaskEntity> uncheckedTasks;
  final Map<String, TaskEntity> inProgressTasks;
  final Map<String, TaskEntity> doneTasks;

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

  @override
  List<Object> get props => [
        allTasks,
        uncheckedTasks,
        inProgressTasks,
        doneTasks,
      ];

  HomeState copyWith({
    Map<String, TaskEntity>? allTasks,
    Map<String, TaskEntity>? uncheckedTasks,
    Map<String, TaskEntity>? inProgressTasks,
    Map<String, TaskEntity>? doneTasks,
  }) {
    return HomeState(
      allTasks: allTasks ?? this.allTasks,
      uncheckedTasks: uncheckedTasks ?? this.uncheckedTasks,
      inProgressTasks: inProgressTasks ?? this.inProgressTasks,
      doneTasks: doneTasks ?? this.doneTasks,
    );
  }
}
