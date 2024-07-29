// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:awesome_to_do/core/data/datasources/core_local_datasource.dart'
    as _i734;
import 'package:awesome_to_do/core/data/datasources/core_remote_datasource.dart'
    as _i543;
import 'package:awesome_to_do/features/home/data/repositories/tasks_repository_impl.dart'
    as _i461;
import 'package:awesome_to_do/features/home/domain/repositories/tasks_repository.dart'
    as _i724;
import 'package:awesome_to_do/features/login/data/repositories/auth_repository_impl.dart'
    as _i705;
import 'package:awesome_to_do/features/login/domain/repositories/auth_repository.dart'
    as _i48;
import 'package:awesome_to_do/injection.dart' as _i32;
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:hive/hive.dart' as _i979;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i979.HiveInterface>(() => registerModule.hive);
    gh.lazySingleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(
        () => registerModule.firebaseFirestore);
    gh.lazySingleton<_i116.GoogleSignIn>(() => registerModule.googleSignIn);
    await gh.lazySingletonAsync<_i460.SharedPreferences>(
      () => registerModule.prefs(),
      preResolve: true,
    );
    gh.lazySingleton<_i543.CoreRemoteDatasource>(
        () => _i543.CoreRemoteDatasourceImpl());
    gh.lazySingleton<_i734.CoreLocalDataSource>(
        () => _i734.CoreLocalDataSourceImpl(
              sharedPreferences: gh<_i460.SharedPreferences>(),
              hiveInterface: gh<_i979.HiveInterface>(),
            ));
    gh.lazySingleton<_i48.AuthRepository>(() => _i705.AuthRepositoryImpl(
          coreLocalDataSource: gh<_i734.CoreLocalDataSource>(),
          firebaseAuth: gh<_i59.FirebaseAuth>(),
          googleSignIn: gh<_i116.GoogleSignIn>(),
        ));
    gh.lazySingleton<_i724.TasksRepository>(() => _i461.TasksRepositoryImpl(
          coreLocalDataSource: gh<_i734.CoreLocalDataSource>(),
          fireStore: gh<_i974.FirebaseFirestore>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i32.RegisterModule {}
