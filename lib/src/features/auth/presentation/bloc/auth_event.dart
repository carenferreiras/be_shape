import '../../auth.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const SignUpRequested(this.email, this.password, this.name);
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const SignInRequested(this.email, this.password, this.name);
}

class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthStateChanged extends AuthEvent {
  final bool isAuthenticated;
  final UserProfile? userProfile; // Tornando opcional com ?

  const AuthStateChanged(this.isAuthenticated, {this.userProfile}); // Tornando um parâmetro nomeado opcional
}
class UpdateUserProfile extends AuthEvent {
  final UserProfile userProfile;
  UpdateUserProfile(this.userProfile);
}

