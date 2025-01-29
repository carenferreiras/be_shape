import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../health.dart';

class HealthPage extends StatelessWidget {
  const HealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Health Data",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: BlocProvider(
        create: (context) => HealthBloc(
          FetchHealthData(context.read()),
        )..add(FetchHealthEvent()),
        child: BlocBuilder<HealthBloc, HealthState>(
          builder: (context, state) {
            if (state is HealthLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.deepPurpleAccent),
              );
            } else if (state is HealthLoaded) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: state.data.length,
                  itemBuilder: (context, index) {
                    final data = state.data[index];
                    return _buildCustomHealthCard(data);
                  },
                ),
              );
            } else if (state is HealthError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 50),
                    const SizedBox(height: 16),
                    Text(
                      "Error: ${state.message}",
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return const Center(
              child: Text("Press Fetch to load data"),
            );
          },
        ),
      ),
    );
  }

  // Função para construir um cartão personalizado para cada dado
  Widget _buildCustomHealthCard(HealthData data) {
    if (data.type == "Steps") {
      return _buildStepsCard(data);
    }
    return _buildGenericCard(data);
  }

  // Componente para o cartão de contagem de passos
  Widget _buildStepsCard(HealthData data) {
    const int goalSteps = 10000; // Meta de passos
    final double progress = (data.value / goalSteps).clamp(0.0, 1.0);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    radius: 30,
                    child: Icon(
                      Icons.directions_walk,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Steps",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple.shade900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${data.value} steps",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.deepPurple.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Barra de progresso para mostrar a meta de passos
              LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.deepPurple.shade100,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 8),
              Text(
                "Goal: $goalSteps steps",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.deepPurple.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Componente genérico para outros dados
  Widget _buildGenericCard(HealthData data) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: Icon(
                  _getIconForType(data.type),
                  color: Colors.deepPurple,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.type,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Value: ${data.value}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função para retornar um ícone com base no tipo de dado
  IconData _getIconForType(String type) {
    switch (type) {
      case "Steps":
        return Icons.directions_walk;
      case "Heart Rate":
        return Icons.favorite;
      case "Calories Burned":
        return Icons.local_fire_department;
      case "Sleep":
        return Icons.bedtime;
      case "Weight":
        return Icons.monitor_weight;
      case "Height":
        return Icons.height;
      default:
        return Icons.health_and_safety;
    }
  }
}