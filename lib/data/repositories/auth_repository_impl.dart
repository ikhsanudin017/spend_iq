import '../../core/errors/exceptions.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth/auth_local_datasource.dart';
import '../datasources/auth/firebase_auth_datasource.dart';
import '../models/user_model.dart';

/// Authentication Repository Implementation
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required FirebaseAuthDatasource? firebaseAuth,
    required AuthLocalDatasource localAuth,
  })  : _firebaseAuth = firebaseAuth,
        _localAuth = localAuth;

  final FirebaseAuthDatasource? _firebaseAuth;
  final AuthLocalDatasource _localAuth;

  void _ensureFirebaseAvailable() {
    if (_firebaseAuth == null) {
      throw const AuthException(
        'Firebase belum dikonfigurasi. Lihat QUICK_START_FIREBASE.md untuk setup.',
      );
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    if (_firebaseAuth == null) return null;
    
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;

    final hasOnboarding = await _localAuth.hasCompletedOnboarding(
      firebaseUser.uid,
    );

    return UserModel.fromFirebaseUser(
      firebaseUser,
      hasCompletedOnboarding: hasOnboarding,
    ).toEntity();
  }

  @override
  Stream<User?> get authStateChanges {
    if (_firebaseAuth == null) {
      return Stream.value(null);
    }
    
    return _firebaseAuth.authStateChanges.asyncMap(
      (firebaseUser) async {
        if (firebaseUser == null) return null;

        final hasOnboarding = await _localAuth.hasCompletedOnboarding(
          firebaseUser.uid,
        );

        return UserModel.fromFirebaseUser(
          firebaseUser,
          hasCompletedOnboarding: hasOnboarding,
        ).toEntity();
      },
    );
  }

  @override
  Future<User> signInWithGoogle() async {
    _ensureFirebaseAvailable();
    
    final firebaseUser = await _firebaseAuth!.signInWithGoogle();
    await _localAuth.saveLastUserId(firebaseUser.uid);

    final hasOnboarding = await _localAuth.hasCompletedOnboarding(
      firebaseUser.uid,
    );

    return UserModel.fromFirebaseUser(
      firebaseUser,
      hasCompletedOnboarding: hasOnboarding,
    ).toEntity();
  }

  @override
  Future<User> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    _ensureFirebaseAvailable();
    
    final firebaseUser = await _firebaseAuth!.signInWithEmailPassword(
      email: email,
      password: password,
    );
    await _localAuth.saveLastUserId(firebaseUser.uid);

    final hasOnboarding = await _localAuth.hasCompletedOnboarding(
      firebaseUser.uid,
    );

    return UserModel.fromFirebaseUser(
      firebaseUser,
      hasCompletedOnboarding: hasOnboarding,
    ).toEntity();
  }

  @override
  Future<User> registerWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    _ensureFirebaseAvailable();
    
    final firebaseUser = await _firebaseAuth!.registerWithEmailPassword(
      email: email,
      password: password,
      displayName: displayName,
    );
    await _localAuth.saveLastUserId(firebaseUser.uid);

    // New users haven't completed onboarding
    return UserModel.fromFirebaseUser(
      firebaseUser,
    ).toEntity();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    _ensureFirebaseAvailable();
    return _firebaseAuth!.sendPasswordResetEmail(email);
  }

  @override
  Future<void> signOut() async {
    if (_firebaseAuth != null) {
      await _firebaseAuth.signOut();
    }
    await _localAuth.clearAuthData();
  }

  @override
  Future<void> deleteAccount() async {
    _ensureFirebaseAvailable();
    await _firebaseAuth!.deleteAccount();
    await _localAuth.clearAuthData();
  }

  @override
  Future<bool> hasCompletedOnboarding() async {
    if (_firebaseAuth == null) return false;
    
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return false;

    return _localAuth.hasCompletedOnboarding(firebaseUser.uid);
  }

  @override
  Future<void> setOnboardingCompleted() async {
    if (_firebaseAuth == null) return;
    
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return;

    await _localAuth.setOnboardingCompleted(firebaseUser.uid);
  }
}



