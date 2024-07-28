import 'dart:async';

import 'package:awesome_to_do/features/login/domain/entities/user_entity.dart';
import 'package:awesome_to_do/features/login/domain/repositories/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required AuthRepository authRepository,
  })  : _authenticationRepository = authRepository,
        super(
          authRepository.currentUser.isNotEmpty
              ? AppState.authenticated(authRepository.currentUser)
              : const AppState.unauthenticated(),
        ) {
    on<_AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(_AppUserChanged(user)),
    );
  }

  final AuthRepository _authenticationRepository;
  late final StreamSubscription<UserEntity> _userSubscription;

  PackageInfo? _packageInfo;

  void init() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  String get appName => _packageInfo?.appName ?? 'Awesome ToDo';

  String get appVersion {
    if (_packageInfo == null) return '';
    return kReleaseMode
        ? _packageInfo!.version
        : '${_packageInfo!.version} | ${_packageInfo!.buildNumber} | ${_getBuildMode()}';
  }

  String _getBuildMode() {
    if (kDebugMode) {
      return 'Debug';
    }
    if (kProfileMode) {
      return ' Profile';
    }
    return 'Release';
  }

  void _onUserChanged(_AppUserChanged event, Emitter<AppState> emit) {
    emit(
      event.user.isNotEmpty
          ? AppState.authenticated(event.user)
          : const AppState.unauthenticated(),
    );
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authenticationRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
