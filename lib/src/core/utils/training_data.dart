// Add this at the top of the file after the imports
import 'package:flutter/material.dart';

final Map<String, List<String>> trainingData = {
  'Leg Press': [
    'Leg Press Tradicional',
    'Leg Press Alto',
    'Leg Press Unilateral',
    'Panturrilha no Leg Press',
    'Leg Press Sumo',
  ],
  'Smith Machine': [
    'Agachamento Smith',
    'Supino Smith',
    'Desenvolvimento Smith',
    'Remada Smith',
    'Elevação de Panturrilha',
  ],
  'Hack Squat': [
    'Hack Squat Tradicional',
    'Hack Squat Sumo',
    'Hack Squat Unilateral',
    'Elevação de Panturrilha',
  ],
  'Cadeira Extensora': [
    'Extensão de Pernas',
    'Extensão Unilateral',
    'Drop Set Extensora',
    'Isometria Extensora',
  ],
  'Cadeira Flexora': [
    'Flexão de Pernas',
    'Flexão Unilateral',
    'Drop Set Flexora',
    'Isometria Flexora',
  ],
  'Pec Deck': [
    'Pec Deck Tradicional',
    'Pec Deck Invertido (Posterior)',
    'Pec Deck Unilateral',
    'Isometria Peitoral',
  ],
  'Graviton': [
    'Pull-up Assistido',
    'Dips Assistido',
    'Chin-up Assistido',
    'Puxada Neutra',
  ],
  'Banco Scott': [
    'Rosca Scott Barra',
    'Rosca Scott Halter',
    'Rosca Scott Unilateral',
    'Rosca Martelo Scott',
  ],
  'Máquina Panturrilha': [
    'Elevação de Panturrilha em Pé',
    'Elevação de Panturrilha Sentado',
    'Elevação Unilateral',
    'Isometria de Panturrilha',
  ],
  'Esteira': [
    'Caminhada',
    'Corrida',
    'Sprint Intervals',
    'Incline Walk',
    'HIIT na Esteira',
  ],
  'Bicicleta Ergométrica': [
    'Pedalada Contínua',
    'Sprint Intervals',
    'Hill Climb',
    'HIIT Bike',
    'Recuperação Ativa',
  ],
  'Elíptico': [
    'Cardio Contínuo',
    'Intervals',
    'Reverse Stride',
    'HIIT Elíptico',
    'Warm-up',
  ],
};

final Map<String, IconData> equipmentIcons = {
  'Leg Press': Icons.fitness_center,
  'Smith Machine': Icons.fitness_center,
  'Hack Squat': Icons.fitness_center,
  'Cadeira Extensora': Icons.chair,
  'Cadeira Flexora': Icons.chair,
  'Pec Deck': Icons.fitness_center,
  'Graviton': Icons.fitness_center,
  'Banco Scott': Icons.weekend,
  'Máquina Panturrilha': Icons.fitness_center,
  'Esteira': Icons.directions_run,
  'Bicicleta Ergométrica': Icons.directions_bike,
  'Elíptico': Icons.directions_run,
};
