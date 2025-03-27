import '../../auth.dart';

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;
  final UserProfile? userProfile;
  final bool isInitialized; 

  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = false,
    this.error,
    this.userProfile,
    this.isInitialized = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
    UserProfile? userProfile,
    bool? isInitialized,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      userProfile: userProfile ?? this.userProfile,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}
