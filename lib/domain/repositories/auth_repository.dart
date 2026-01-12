import '../entities/user.dart';

/// Authentication Repository Interface
abstract class AuthRepository {
  /// Get current authenticated user
  Future<User?> getCurrentUser();

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges;

  /// Sign in with Google
  Future<User> signInWithGoogle();

  /// Sign in with email and password
  Future<User> signInWithEmailPassword({
    required String email,
    required String password,
  });

  /// Register with email and password
  Future<User> registerWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
  });

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email);

  /// Sign out
  Future<void> signOut();

  /// Delete account
  Future<void> deleteAccount();

  /// Check if user has completed onboarding
  Future<bool> hasCompletedOnboarding();

  /// Mark onboarding as completed
  Future<void> setOnboardingCompleted();
}











