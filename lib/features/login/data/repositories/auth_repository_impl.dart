import 'package:awesome_to_do/features/login/domain/entities/user_entity.dart';
import 'package:awesome_to_do/features/login/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/data/datasources/core_local_datasource.dart';
import '../../../../core/failures.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final CoreLocalDataSource coreLocalDataSource;
  final fb_auth.FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthRepositoryImpl({
    required this.coreLocalDataSource,
    required this.firebaseAuth,
    required this.googleSignIn,
  });

  /// User cache key.
  /// Should only be used for testing purposes.
  // @visibleForTesting
  // static const userCacheKey = '__user_cache_key__';

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  @override
  Stream<UserEntity> get user {
    return firebaseAuth.authStateChanges().map((firebaseUser) {
      final UserEntity user =
          firebaseUser == null ? UserEntity.empty : firebaseUser.toUser;
      coreLocalDataSource.cacheLoggedInUser(user);
      return user;
    });
  }

  /// Returns the current cached user.
  /// Defaults to [UserEntity.empty] if there is no cached user.
  @override
  UserEntity get currentUser {
    return coreLocalDataSource.getLoggedInUserFromCache() ?? UserEntity.empty;
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      throw const SignUpWithEmailAndPasswordFailure(
          'Email and Password cannot be empty');
    }
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on fb_auth.FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  @override
  Future<void> logInWithGoogle() async {
    try {
      late final fb_auth.AuthCredential credential;
      if (kIsWeb) {
        final googleProvider = fb_auth.GoogleAuthProvider();
        final userCredential = await firebaseAuth.signInWithPopup(
          googleProvider,
        );
        credential = userCredential.credential!;
      } else {
        final googleUser = await googleSignIn.signIn();
        final googleAuth = await googleUser!.authentication;
        credential = fb_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      }

      await firebaseAuth.signInWithCredential(credential);
    } on fb_auth.FirebaseAuthException catch (e) {
      throw LogInWithGoogleFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithGoogleFailure();
    }
  }

  @override
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on fb_auth.FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await Future.wait([
        firebaseAuth.signOut(),
        googleSignIn.signOut(),
      ]);
    } catch (_) {
      throw const LogOutFailure();
    }
  }
}

extension on fb_auth.User {
  /// Maps a [firebase_auth.User] into a [User].
  UserEntity get toUser {
    return UserEntity(
      id: uid,
      email: email,
      name: displayName,
      photo: photoURL,
    );
  }
}
