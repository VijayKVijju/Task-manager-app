import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Stream of user auth state (null if signed out)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Current logged-in user
  User? get currentUser => _auth.currentUser;

  /// Sign up with email and password
  Future<User?> signUp(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Sign-up failed");
    }
  }

  /// Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? "Sign-in failed");
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
