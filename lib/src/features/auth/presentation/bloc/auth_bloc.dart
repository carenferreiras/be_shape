import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  late final StreamSubscription<dynamic> _authStateSubscription;

  AuthBloc({
    required AuthRepository authRepository,
    required UserRepository userRepository,})
      : _authRepository = authRepository,
        _userRepository = userRepository,
        super(const AuthState()) {
    on<SignUpRequested>(_onSignUpRequested);
    on<SignInRequested>(_onSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthStateChanged>(_onAuthStateChanged);

    // Subscribe to auth state changes
    _authStateSubscription = _authRepository.authStateChanges.listen(
      (user) => add(AuthStateChanged(user != null)),
    );
  }
Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final userCredential = await _authRepository.signUp(event.email, event.password);

      // Crie o perfil do usuário com o nome fornecido
      final userId = userCredential.user?.uid;
      if (userId != null) {
        final userProfile = UserProfile(
          id: userId,
          name: event.name,
          age: 0,
          gender: 'Not Specified',
          height: 0.0,
          weight: 0.0,
          targetWeight: 0.0,
          goal: '',
          measurements: {},
        );
        // Use o UserRepository para salvar o perfil
        await _userRepository.saveUserProfile(userProfile);
      }

      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _authRepository.signIn(event.email, event.password);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _authRepository.signOut();
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = _authRepository.currentUser;
    emit(state.copyWith(isAuthenticated: user != null));
  }

  void _onAuthStateChanged(
    AuthStateChanged event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(isAuthenticated: event.isAuthenticated));
  }

  @override
  Future<void> close() {
    _authStateSubscription.cancel();
    return super.close();
  }
}