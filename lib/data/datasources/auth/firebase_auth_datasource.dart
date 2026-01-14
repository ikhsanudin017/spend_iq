import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/errors/exceptions.dart';

/// Firebase Authentication Data Source
class FirebaseAuthDatasource {
  FirebaseAuthDatasource()
      : _auth = firebase_auth.FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn();

  final firebase_auth.FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  /// Current user
  firebase_auth.User? get currentUser => _auth.currentUser;

  /// Auth state changes stream
  Stream<firebase_auth.User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with Google
  Future<firebase_auth.User> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw const AuthException('Login dibatalkan oleh user');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw const AuthException('Login gagal');
      }

      return userCredential.user!;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e.code));
    } catch (e) {
      throw AuthException('Login gagal: ${e.toString()}');
    }
  }

  /// Sign in with email and password
  Future<firebase_auth.User> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw const AuthException('Login gagal');
      }

      return userCredential.user!;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e.code));
    }
  }

  /// Register with email and password
  Future<firebase_auth.User> registerWithEmailPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw const AuthException('Registrasi gagal');
      }

      // Update display name
      await userCredential.user!.updateDisplayName(displayName);

      return userCredential.user!;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e.code));
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e.code));
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw AuthException('Logout gagal: ${e.toString()}');
    }
  }

  /// Delete user account
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw const AuthException('User tidak ditemukan');
      }

      await user.delete();
      await _googleSignIn.signOut();
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e.code));
    }
  }

  /// Map Firebase error codes to user-friendly messages
  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Email tidak terdaftar';
      case 'wrong-password':
        return 'Password salah';
      case 'email-already-in-use':
        return 'Email sudah digunakan';
      case 'invalid-email':
        return 'Email tidak valid';
      case 'weak-password':
        return 'Password terlalu lemah';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti';
      case 'network-request-failed':
        return 'Tidak ada koneksi internet';
      case 'requires-recent-login':
        return 'Silakan login ulang untuk melanjutkan';
      default:
        return 'Terjadi kesalahan: $code';
    }
  }
}
