import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/errors/exceptions.dart';

/// Firebase Authentication Data Source
class FirebaseAuthDatasource {
  FirebaseAuthDatasource({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ??
            GoogleSignIn(
              scopes: ['email', 'profile'],
              // Server Client ID dari google-services.json (client_type: 3)
              serverClientId:
                  '143848756273-3d121opc26p46gshrtpppesmj5cql200.apps.googleusercontent.com',
            );

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  /// Get current Firebase user
  firebase_auth.User? get currentUser => _firebaseAuth.currentUser;

  /// Stream of auth state changes
  Stream<firebase_auth.User?> get authStateChanges =>
      _firebaseAuth.authStateChanges();

  /// Sign in with Google
  Future<firebase_auth.User> signInWithGoogle() async {
    try {
      // Sign out any existing Google session first
      await _googleSignIn.signOut();

      // Trigger Google Sign In flow
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const AuthException('Login dibatalkan oleh user');
      }

      // Obtain auth details
      final googleAuth = await googleUser.authentication;

      // Validate tokens
      if (googleAuth.idToken == null) {
        throw const AuthException(
          'ID Token tidak tersedia. Pastikan SHA-1 sudah ditambahkan di Firebase Console.',
        );
      }

      // Create credential
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      if (userCredential.user == null) {
        throw const AuthException('Login gagal: User credential kosong');
      }

      return userCredential.user!;
    } on firebase_auth.FirebaseAuthException catch (e) {
      // Map specific Firebase auth errors
      final errorMessage = _mapGoogleSignInError(e.code, e.message);
      throw AuthException(errorMessage);
    } catch (e) {
      // Handle other errors (PlatformException, etc.)
      final errorString = e.toString();
      if (errorString.contains('sign_in_failed') ||
          errorString.contains('SIGN_IN_FAILED')) {
        throw const AuthException(
          'Login gagal. Pastikan:\n'
          '1. SHA-1 sudah ditambahkan di Firebase Console\n'
          '2. Google Sign-In sudah di-enable di Firebase\n'
          '3. google-services.json sudah benar',
        );
      }
      if (errorString.contains('network') || errorString.contains('NETWORK')) {
        throw const AuthException('Koneksi internet bermasalah. Coba lagi.');
      }
      throw AuthException('Login gagal: ${e.toString()}');
    }
  }

  /// Sign in with email and password
  Future<firebase_auth.User> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw const AuthException('Login gagal');
      }

      return userCredential.user!;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseErrorMessage(e.code));
    }
  }

  /// Register with email and password
  Future<firebase_auth.User> registerWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw const AuthException('Registrasi gagal');
      }

      // Update display name
      await userCredential.user!.updateDisplayName(displayName);
      await userCredential.user!.reload();

      return _firebaseAuth.currentUser!;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseErrorMessage(e.code));
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseErrorMessage(e.code));
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw AuthException('Logout gagal: $e');
    }
  }

  /// Delete account
  Future<void> deleteAccount() async {
    try {
      await currentUser?.delete();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseErrorMessage(e.code));
    }
  }

  /// Map Firebase error codes to user-friendly messages
  String _mapFirebaseErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Email tidak ditemukan';
      case 'wrong-password':
        return 'Password salah';
      case 'email-already-in-use':
        return 'Email sudah terdaftar';
      case 'invalid-email':
        return 'Format email tidak valid';
      case 'weak-password':
        return 'Password terlalu lemah (minimal 6 karakter)';
      case 'user-disabled':
        return 'Akun dinonaktifkan';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti';
      case 'operation-not-allowed':
        return 'Metode login tidak diaktifkan';
      case 'requires-recent-login':
        return 'Silakan login ulang untuk melanjutkan';
      default:
        return 'Terjadi kesalahan: $code';
    }
  }

  /// Map Google Sign-In specific errors
  String _mapGoogleSignInError(String code, String? message) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return 'Akun sudah terdaftar dengan metode lain. Gunakan email/password.';
      case 'invalid-credential':
        return 'Kredensial tidak valid. Coba login ulang.';
      case 'operation-not-allowed':
        return 'Google Sign-In belum diaktifkan di Firebase Console.';
      case 'user-disabled':
        return 'Akun dinonaktifkan. Hubungi support.';
      case 'user-not-found':
        return 'Akun tidak ditemukan. Silakan daftar terlebih dahulu.';
      case 'wrong-password':
        return 'Password salah.';
      case 'invalid-verification-code':
        return 'Kode verifikasi tidak valid.';
      case 'invalid-verification-id':
        return 'ID verifikasi tidak valid.';
      case 'network-request-failed':
        return 'Koneksi internet bermasalah. Periksa koneksi Anda.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Tunggu beberapa saat.';
      default:
        return message ?? 'Login gagal: $code';
    }
  }
}

