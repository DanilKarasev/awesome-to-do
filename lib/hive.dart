import 'package:awesome_to_do/core/constants/db_constants.dart';
import 'package:awesome_to_do/features/login/data/hive_objects/user_hive_object.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Future<void> initHive() async {
  final String? path =
      kIsWeb ? null : (await getApplicationDocumentsDirectory()).path;
  Hive.init(path);

  // Register [TypeAdapter]s
  Hive.registerAdapter(UserHiveObjectAdapter());
  // Open boxes to be used throughout the app for faster accessing later on
  await Hive.openBox<UserHiveObject>(HiveBoxes.userBox);
}
