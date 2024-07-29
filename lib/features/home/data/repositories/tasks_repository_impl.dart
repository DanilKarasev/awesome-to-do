import 'package:awesome_to_do/core/constants/db_constants.dart';
import 'package:awesome_to_do/features/home/domain/repositories/tasks_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/data/datasources/core_local_datasource.dart';
import '../../../../core/failures.dart';
import '../../domain/entities/task_entity.dart';
import '../models/task_model.dart';

@LazySingleton(as: TasksRepository)
class TasksRepositoryImpl implements TasksRepository {
  final CoreLocalDataSource coreLocalDataSource;
  final FirebaseFirestore fireStore;

  TasksRepositoryImpl({
    required this.coreLocalDataSource,
    required this.fireStore,
  });

  @override
  Future<void> createNew(
    TaskEntity task, {
    String workspaceId = FS.defaultWorkspaceCollectionId,
  }) async {
    try {
      await fireStore
          .collection(FS.tasks)
          .doc(workspaceId)
          .collection(task.status.fsCollectionId)
          .add(TaskModel.fromEntity(task).toJson());
    } catch (e) {
      throw AddTaskFailure('Failed to add task: ${e.toString()}');
    }
  }

  @override
  Future<void> updateExisting(
    TaskEntity task, {
    String workspaceId = FS.defaultWorkspaceCollectionId,
  }) async {
    try {
      await fireStore
          .collection(FS.tasks)
          .doc(workspaceId)
          .collection(task.status.fsCollectionId)
          .doc(task.id)
          .update(TaskModel.fromEntity(task).toJson());
    } catch (e) {
      throw AddTaskFailure('Failed to add task: ${e.toString()}');
    }
  }

  @override
  Future<void> moveToAnotherCollection(
    TaskEntity task,
    TaskStatus newCollection, {
    String workspaceId = FS.defaultWorkspaceCollectionId,
  }) async {
    try {
      await deleteTask(task);
      await createNew(task.copyWith(status: newCollection));
    } catch (e) {
      throw AddTaskFailure('Failed to add task: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteTask(
    TaskEntity task, {
    String workspaceId = FS.defaultWorkspaceCollectionId,
  }) async {
    try {
      await fireStore
          .collection(FS.tasks)
          .doc(workspaceId)
          .collection(task.status.fsCollectionId)
          .doc(task.id)
          .delete();
    } catch (e) {
      throw DeleteTaskFailure('Failed to delete task: ${e.toString()}');
    }
  }

  @override
  Future<List<TaskEntity>> getTasksList(
    TaskStatus collectionToFetch, {
    String workspaceId = FS.defaultWorkspaceCollectionId,
  }) async {
    try {
      QuerySnapshot snapshot = await fireStore
          .collection(FS.tasks)
          .doc(workspaceId)
          .collection(collectionToFetch.fsCollectionId)
          .get();

      return snapshot.docs.map((doc) {
        return TaskModel.fromJson(
          {
            ...doc.data() as Map<String, dynamic>,
            'id': doc.id,
          },
        ).toEntity();
      }).toList();
    } catch (e) {
      throw GetTasksFailure('Failed to get tasks: ${e.toString()}');
    }
  }

  @override
  Stream<List<TaskEntity>> getTasksStream(
    TaskStatus collectionToFetch, {
    String workspaceId = FS.defaultWorkspaceCollectionId,
  }) {
    try {
      return fireStore
          .collection(FS.tasks)
          .doc(workspaceId)
          .collection(collectionToFetch.fsCollectionId)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map(
          (doc) {
            return TaskModel.fromJson({
              ...doc.data(),
              'id': doc.id,
            }).toEntity();
          },
        ).toList();
      });
    } catch (e) {
      throw GetTasksFailure('Failed to get tasks: ${e.toString()}');
    }
  }
}
