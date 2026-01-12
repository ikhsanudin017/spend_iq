import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

/// User entity - represents authenticated user
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String displayName,
    String? photoUrl,
    String? phoneNumber,
    required DateTime createdAt,
    DateTime? lastLoginAt,
    @Default(false) bool hasCompletedOnboarding,
  }) = _User;

  const User._();

  /// Get first name from display name
  String get firstName {
    final parts = displayName.split(' ');
    return parts.isNotEmpty ? parts.first : displayName;
  }

  /// Get initials for avatar
  String get initials {
    final parts = displayName.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
  }
}











