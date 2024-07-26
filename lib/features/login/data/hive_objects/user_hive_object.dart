import 'package:awesome_to_do/core/constants/db_constants.dart';
import 'package:awesome_to_do/features/login/domain/entities/user_entity.dart';
import 'package:hive/hive.dart';

import '../models/user_model.dart';

part 'user_hive_object.g.dart';

@HiveType(typeId: HiveTypeIds.userTypeId)
class UserHiveObject extends HiveObject {
  /// The current user's id.
  @HiveField(0)
  final String id;

  /// The current user's email address.
  @HiveField(1)
  final String? email;

  /// The current user's name (display name).
  @HiveField(2)
  final String? name;

  /// Url for the current user's photo.
  @HiveField(3)
  final String? photo;

  UserHiveObject({
    required this.id,
    required this.email,
    required this.name,
    required this.photo,
  });

  factory UserHiveObject.fromModel(UserModel model) {
    return UserHiveObject(
      id: model.id,
      email: model.email,
      name: model.name,
      photo: model.photo,
    );
  }

  factory UserHiveObject.fromEntity(UserEntity entity) {
    return UserHiveObject(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      photo: entity.photo,
    );
  }

  UserModel toModel() {
    return UserModel(
      id: id,
      email: email,
      name: name,
      photo: photo,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      photo: photo,
    );
  }
}
