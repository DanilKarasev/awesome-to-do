mixin DBKeys {
  static const String loggedInUserKey = 'logged_in_user_key';
}

mixin HiveTypeIds {
  static const int userTypeId = 0;
}

mixin HiveBoxes {
  static const String userBox = 'user_hive_box';
}

mixin FS {
  static const String workspaces = 'workspaces';
  static const String tasks = 'tasks';
  static const String backlogTasks = 'backlog';
  static const String inProgressTasks = 'in_progress';
  static const String completedTasks = 'completed';

  //TODO: If will have time - implement workspace collection. For now hardcoding
  static const defaultWorkspaceCollectionId = 'nLFks3YUK6SvXh1zpLHu';
}
