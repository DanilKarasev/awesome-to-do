import 'package:awesome_to_do/features/login/data/hive_objects/user_hive_object.dart';
import 'package:awesome_to_do/features/login/domain/entities/user_entity.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/db_constants.dart';

abstract class CoreLocalDataSource {
  UserEntity? getLoggedInUserFromCache();
  Future<void> cacheLoggedInUser(UserEntity user);
}

@LazySingleton(as: CoreLocalDataSource)
class CoreLocalDataSourceImpl implements CoreLocalDataSource {
  final SharedPreferences sharedPreferences;
  final HiveInterface hiveInterface;

  CoreLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.hiveInterface,
  });

  @override
  UserEntity? getLoggedInUserFromCache() {
    final Box<UserHiveObject> userBox =
        hiveInterface.box<UserHiveObject>(HiveBoxes.userBox);
    return userBox.get(DBKeys.loggedInUserKey)?.toEntity();
  }

  @override
  Future<void> cacheLoggedInUser(UserEntity user) async {
    final Box<UserHiveObject> userBox =
        hiveInterface.box<UserHiveObject>(HiveBoxes.userBox);
    await userBox.put(DBKeys.loggedInUserKey, UserHiveObject.fromEntity(user));
  }
}
