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
  final String name; // Adicionado

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

  const AuthStateChanged(this.isAuthenticated);
}
