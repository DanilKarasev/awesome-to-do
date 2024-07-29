import 'package:awesome_to_do/core/constants/color_constants.dart';
import 'package:awesome_to_do/core/utils/date_time_extensions.dart';
import 'package:awesome_to_do/core/utils/string_extensons.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/db_constants.dart';

enum TaskStatus {
  unchecked('unchecked', failureColor, Icons.warning_rounded),
  doing('doing', alertColor, Icons.pending),
  done('done', successColor, Icons.task_alt);

  bool get isUnchecked => this == TaskStatus.unchecked;
  bool get isDoing => this == TaskStatus.doing;
  bool get isDone => this == TaskStatus.done;

  String get displayLbl => lbl.capitalize();

  String get fsCollectionId {
    if (isDoing) {
      return FS.inProgressTasks;
    }
    if (isDone) {
      return FS.completedTasks;
    }
    return FS.backlogTasks;
  }

  static TaskStatus fromJson(String? val) {
    switch (val) {
      case 'in_progress':
        return TaskStatus.doing;
      case 'done':
        return TaskStatus.done;
      case 'backlog':
      default:
        return TaskStatus.unchecked;
    }
  }

  String get dbRecordStringVal {
    switch (this) {
      case TaskStatus.doing:
        return 'in_progress';
      case TaskStatus.done:
        return 'done';
      case TaskStatus.unchecked:
      default:
        return 'backlog';
    }
  }

  final String lbl;
  final Color color;
  final IconData iconData;
  const TaskStatus(
    this.lbl,
    this.color,
    this.iconData,
  );
}

class TaskEntity extends Equatable {
  const TaskEntity({
    required this.id,
    required this.requestorId,
    required this.ownerId,
    required this.title,
    required this.dateCreated,
    this.dueDate,
    this.description,
    this.shortDescription,
    this.status = TaskStatus.unchecked,
  });

  //Required fields
  final String id;
  final String requestorId;
  final String ownerId;
  final String title;
  final DateTime dateCreated;

  //Not required
  final DateTime? dueDate;
  final String? description;
  final String? shortDescription;
  final TaskStatus status;

  bool get isUnchecked => status.isUnchecked;
  bool get isDoing => status.isDoing;
  bool get isDone => status.isDone;

  TaskStatus? get nextStage {
    if (isUnchecked) {
      return TaskStatus.doing;
    }
    if (isDoing) {
      return TaskStatus.done;
    }
    return null;
  }

  TaskStatus? get previousStage {
    if (isDone) {
      return TaskStatus.doing;
    }
    if (isDoing) {
      return TaskStatus.unchecked;
    }
    return null;
  }

  static TaskEntity dummy({TaskStatus? status}) => TaskEntity(
        id: const Uuid().v4(),
        requestorId: const Uuid().v4(),
        ownerId: const Uuid().v4(),
        title: 'Dummy Title',
        dateCreated: DateTime(1994, 8, 11),
        dueDate: DateTime(2024, 8, 11),
        description:
            'Dummy Full Description. Dummy Full Description. Dummy Full Description. Dummy Full Description. Dummy Full Description. Dummy Full Description. ',
        shortDescription: 'Dummy Shot Description',
        status: status ?? TaskStatus.unchecked,
      );

  bool get isOverdue {
    if (isDone || dueDate == null) {
      return false;
    }
    final Duration difference =
        dueDate!.toMidnight().difference(DateTime.now());
    if (difference.inDays < 0) {
      return true;
    }
    return false;
  }

  ({IconData icon, Color color}) get statusIcon {
    if (isDone) {
      return (icon: Icons.task_alt, color: successColor);
    }
    if (isDoing) {
      return (icon: Icons.pending, color: alertColor);
    }
    return (icon: Icons.warning_rounded, color: failureColor);
  }

  @override
  List<Object?> get props => [
        id,
        requestorId,
        ownerId,
        title,
        dateCreated,
        dueDate,
        description,
        shortDescription,
        status,
      ];

  TaskEntity copyWith({
    String? id,
    String? requestorId,
    String? ownerId,
    String? title,
    DateTime? dateCreated,
    DateTime? dueDate,
    String? description,
    String? shortDescription,
    TaskStatus? status,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      requestorId: requestorId ?? this.requestorId,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      dateCreated: dateCreated ?? this.dateCreated,
      dueDate: dueDate ?? this.dueDate,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      status: status ?? this.status,
    );
  }
}
