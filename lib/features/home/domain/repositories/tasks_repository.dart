import '../../../../core/constants/db_constants.dart';
import '../entities/task_entity.dart';

abstract class TasksRepository {
  Future<void> createNew(
    TaskEntity task, {
    String workspaceId = FS.defaultWorkspaceCollectionId,
  });

  Future<void> updateExisting(
    TaskEntity newValue, {
    String workspaceId = FS.defaultWorkspaceCollectionId,
  });

  Future<void> moveToAnotherCollection(
    TaskEntity task,
    TaskStatus newCollection, {
    String workspaceId = FS.defaultWorkspaceCollectionId,
  });

  Future<void> deleteTask(
    TaskEntity task, {
    String workspaceId = FS.defaultWorkspaceCollectionId,
  });

  Future<List<TaskEntity>> getTasksList(
    TaskStatus collectionToFetch, {
    String workspaceId = FS.defaultWorkspaceCollectionId,
  });

  Stream<List<TaskEntity>> getTasksStream(
    TaskStatus collectionToFetch, {
    String workspaceId = FS.defaultWorkspaceCollectionId,
  });
}
