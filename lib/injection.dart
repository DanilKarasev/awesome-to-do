import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@module
abstract class RegisterModule {
  @LazySingleton()
  @preResolve
  Future<SharedPreferences> prefs() => SharedPreferences.getInstance();

  @LazySingleton()
  HiveInterface get hive => Hive;

  @LazySingleton()
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @LazySingleton()
  GoogleSignIn get googleSignIn => GoogleSignIn.standard();
}

@injectableInit
Future<void> configureInjection() async => getIt.init();
