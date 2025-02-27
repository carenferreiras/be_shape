// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  late final StreamSubscription<dynamic> _authStateSubscription;

  AuthBloc({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        super(const AuthState()) {
          // No AuthBloc
on<UpdateUserProfile>((event, emit) {
  emit(state.copyWith(userProfile: event.userProfile));
});
    on<SignUpRequested>(_onSignUpRequested);
    on<SignInRequested>(_onSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthStateChanged>(_onAuthStateChanged);

    // Verifica o estado inicial de autenticação
    _checkInitialAuthState();

      // Subscribe to auth state changes
    _authStateSubscription = _authRepository.authStateChanges.listen(
      (user) async {
        if (user != null) {
          try {
            final userProfile = await _userRepository.getUserProfile(user.uid);
            add(AuthStateChanged(true, userProfile: userProfile));
          } catch (e) {
            print('Error loading user profile: $e');
            add(const AuthStateChanged(false));
          }
        } else {
          add(const AuthStateChanged(false));
        }
      },
    );
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      
      // Registrar o usuário
      final userCredential = await _authRepository.signUp(
        event.email,
        event.password,
      );

      // O usuário estará autenticado, mas sem perfil ainda
      emit(state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        userProfile: null, // Perfil será criado no onboarding
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }


  Future<void> _checkInitialAuthState() async {
    try {
      emit(state.copyWith(isLoading: true));
      final user = _authRepository.currentUser;
      
      if (user != null) {
        final userProfile = await _userRepository.getUserProfile(user.uid);
        emit(state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          userProfile: userProfile,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          isAuthenticated: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final userCredential = await _authRepository.signIn(event.email, event.password);
      final userProfile = await _userRepository.getUserProfile(userCredential.user!.uid);
      
      emit(state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        userProfile: userProfile,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _authRepository.signOut();
      emit(const AuthState());
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final user = _authRepository.currentUser;
      
      if (user != null) {
        final userProfile = await _userRepository.getUserProfile(user.uid);
        emit(state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          userProfile: userProfile,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          isAuthenticated: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }
  void _onAuthStateChanged(
    AuthStateChanged event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(
      isAuthenticated: event.isAuthenticated,
      userProfile: event.userProfile,
    ));
  }

  @override
  Future<void> close() {
    _authStateSubscription.cancel();
    return super.close();
  }

  String? get currentUserId => _authRepository.currentUser?.uid;
}