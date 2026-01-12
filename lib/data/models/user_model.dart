import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User model - for serialization/deserialization
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String displayName,
    String? photoUrl,
    String? phoneNumber,
    required DateTime createdAt,
    DateTime? lastLoginAt,
    @Default(false) bool hasCompletedOnboarding,
  }) = _UserModel;

  /// Create from entity
  factory UserModel.fromEntity(User user) => UserModel(
        id: user.id,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoUrl,
        phoneNumber: user.phoneNumber,
        createdAt: user.createdAt,
        lastLoginAt: user.lastLoginAt,
        hasCompletedOnboarding: user.hasCompletedOnboarding,
      );

  /// Create from Firebase User
  factory UserModel.fromFirebaseUser(
    firebase_auth.User firebaseUser, {
    bool hasCompletedOnboarding = false,
  }) =>
      UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName ?? 'User',
        photoUrl: firebaseUser.photoURL,
        phoneNumber: firebaseUser.phoneNumber,
        createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
        lastLoginAt: firebaseUser.metadata.lastSignInTime,
        hasCompletedOnboarding: hasCompletedOnboarding,
      );

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Convert to entity
  User toEntity() => User(
        id: id,
        email: email,
        displayName: displayName,
        photoUrl: photoUrl,
        phoneNumber: phoneNumber,
        createdAt: createdAt,
        lastLoginAt: lastLoginAt,
        hasCompletedOnboarding: hasCompletedOnboarding,
      );
}

