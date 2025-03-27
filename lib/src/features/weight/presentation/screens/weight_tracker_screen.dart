import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features.dart';

class WeightAnimationScreen extends StatelessWidget {
  const WeightAnimationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authRepo = context.read<AuthRepository>();
    final userRepo = context.read<UserRepository>();

    // Pega o usuário autenticado do AuthRepository
    final firebaseUser = authRepo.currentUser;
    if (firebaseUser == null) {
      return Scaffold(
        body: Center(child: Text("Usuário não autenticado")),
      );
    }

    // Carrega o perfil do usuário de forma assíncrona usando o UID do firebaseUser
    return FutureBuilder<UserProfile?>(
      future: userRepo.getUserProfile(firebaseUser.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            body: Center(child: Text("Perfil não encontrado")),
          );
        }

        final userProfile = snapshot.data!;

        return BlocProvider(
          create: (_) => WeightBloc(
            userRepository: userRepo,
            userId: userProfile.id,
            initialWeight: userProfile.weight,
            initialBMR: userProfile.bmr, // valor já armazenado no perfil
            initialTDEE: userProfile.tdee,
          ),
          child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(title: const Text("Controle de Peso")),
            body: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // WeightAnimationView(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
