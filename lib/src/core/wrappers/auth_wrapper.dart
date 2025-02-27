import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../features/features.dart';
import '../core.dart';

class AuthWrapper extends StatelessWidget {
  final Widget child;

  const AuthWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // Limpa mensagens de erro anteriores
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        // Mostra loading durante verificação inicial
        if (state.isLoading) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: SpinKitWaveSpinner(
                color: BeShapeColors.primary,
                size: 50.0,
              ),
            ),
          );
        }

        // Se não estiver autenticado, redireciona para login
        if (!state.isAuthenticated) {
          return const LoginScreen();
        }

        // Se estiver autenticado mas sem perfil, redireciona para onboarding
        if (state.userProfile == null) {
          return const OnboardingScreen();
        }

        // Se estiver tudo ok, mostra o conteúdo principal
        return child;
      },
    );
  }
}