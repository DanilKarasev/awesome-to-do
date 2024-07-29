import 'package:awesome_to_do/features/home/domain/entities/task_entity.dart';
import 'package:uuid/uuid.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.requestorId,
    required super.ownerId,
    required super.title,
    required super.dateCreated,
    super.dueDate,
    super.description,
    super.shortDescription,
    super.status,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      requestorId: json['requestorId'],
      ownerId: json['ownerId'],
      title: json['title'],
      dateCreated:
          DateTime.tryParse(json['dateCreated'] ?? '') ?? DateTime(2024, 1, 1),
      dueDate: DateTime.tryParse(json['dueDate'] ?? ''),
      description: json['description'],
      shortDescription: json['shortDescription'],
      status: TaskStatus.fromJson(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'requestorId': requestorId,
      'ownerId': ownerId,
      'title': title,
      'dateCreated': dateCreated.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'description': description,
      'shortDescription': shortDescription,
      'status': status.dbRecordStringVal,
    };
  }

  static TaskModel fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      requestorId: entity.requestorId,
      ownerId: entity.ownerId,
      title: entity.title,
      dateCreated: entity.dateCreated,
      dueDate: entity.dueDate,
      description: entity.description,
      shortDescription: entity.shortDescription,
      status: entity.status,
    );
  }

  static TaskModel get dummy {
    return TaskModel(
      id: const Uuid().v4(),
      requestorId: const Uuid().v4(),
      ownerId: const Uuid().v4(),
      title: 'Test Task!!',
      description:
          'Test full description. The overflowing RenderFlex has an orientation of Axis.horizontal.',
      shortDescription: 'Short desc',
      dateCreated: DateTime.now(),
      status: TaskStatus.unchecked,
    );
  }

  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      requestorId: requestorId,
      ownerId: ownerId,
      title: title,
      dateCreated: dateCreated,
      dueDate: dueDate,
      description: description,
      shortDescription: shortDescription,
      status: status,
    );
  }
}
