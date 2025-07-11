import 'package:firebase_auth/firebase_auth.dart';

import '../../auth.dart';

abstract class AuthRepository {
  Future<UserCredential> signUp(String email, String password);
  Future<UserCredential> signIn(String email, String password);
  Future<void> signOut();
  Stream<User?> get authStateChanges;
  User? get currentUser;
  Future<UserProfile?> getUserProfile();
}