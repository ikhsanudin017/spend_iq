import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/app_config.dart';
import '../data/datasources/auth/auth_local_datasource.dart';
import '../data/datasources/auth/firebase_auth_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/entities/user.dart';
import '../domain/repositories/auth_repository.dart';

/// Firebase Auth Datasource Provider (Lazy initialization)
final firebaseAuthDatasourceProvider = Provider<FirebaseAuthDatasource?>((ref) {
  try {
    // Only create if Firebase is available
    if (AppBootstrapper.isFirebaseAvailable) {
      return FirebaseAuthDatasource();
    }
  } catch (e) {
    // Firebase not available, return null
    return null;
  }
  return null;
});

/// Auth Local Datasource Provider
final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) => AuthLocalDatasource());

/// Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepositoryImpl(
    firebaseAuth: ref.watch(firebaseAuthDatasourceProvider),
    localAuth: ref.watch(authLocalDatasourceProvider),
  ));

/// Current User Provider
/// Returns the currently authenticated user or null
final currentUserProvider = StreamProvider<User?>((ref) {
  try {
    final authRepo = ref.watch(authRepositoryProvider);
    return authRepo.authStateChanges;
  } catch (e) {
    // Firebase not available, return empty stream
    return Stream.value(null);
  }
});

/// Auth State Provider
/// Provides authentication state: loading, authenticated, or unauthenticated
final authStateProvider = Provider<AsyncValue<User?>>((ref) => ref.watch(currentUserProvider));

/// Is Authenticated Provider
/// Simple boolean to check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.valueOrNull != null;
});



