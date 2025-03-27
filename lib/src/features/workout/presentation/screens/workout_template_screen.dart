import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features.dart';

class WorkoutTemplatesScreen extends StatefulWidget {
  const WorkoutTemplatesScreen({super.key});

  @override
  State<WorkoutTemplatesScreen> createState() => _WorkoutTemplatesScreenState();
}

class _WorkoutTemplatesScreenState extends State<WorkoutTemplatesScreen> {
  final Set<String> _selectedEquipment = {};
  WorkoutType? _selectedType;
  String _selectedDifficulty = 'Todos';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final userId = context.read<AuthBloc>().currentUserId;
    if (userId != null) {
      context.read<EquipmentBloc>().add(LoadUserEquipment(userId));
      context.read<WorkoutBloc>().add(const LoadWorkoutTemplates());
    }
  }

  void _filterWorkouts() {
    if (_selectedEquipment.isNotEmpty) {
      context.read<WorkoutBloc>().add(
            LoadWorkoutsByEquipment(_selectedEquipment.toList()),
          );
    } else {
      context.read<WorkoutBloc>().add(const LoadWorkoutTemplates());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Templates de Treino'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: BlocBuilder<WorkoutBloc, WorkoutState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final templates = state.templates.where((template) {
                  if (_selectedType != null && template.type != _selectedType) {
                    return false;
                  }
                  if (_selectedDifficulty != 'Todos' &&
                      template.difficulty != _selectedDifficulty) {
                    return false;
                  }
                  if (_selectedEquipment.isNotEmpty) {
                    return template.requiredEquipment
                        .any((e) => _selectedEquipment.contains(e));
                  }
                  return true;
                }).toList();

                if (templates.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: (0.2)),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.fitness_center,
                            color: Colors.blue,
                            size: 48,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Nenhum template encontrado',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tente ajustar os filtros',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: templates.length,
                  itemBuilder: (context, index) {
                    return _WorkoutTemplateCard(
                      workout: templates[index],
                      onUse: () => _useTemplate(templates[index]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[800]!,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filtros',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTypeFilter(),
                const SizedBox(width: 16),
                _buildDifficultyFilter(),
                const SizedBox(width: 16),
                _buildEquipmentFilter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<WorkoutType?>(
          value: _selectedType,
          hint: const Text(
            'Tipo',
            style: TextStyle(color: Colors.grey),
          ),
          dropdownColor: Colors.grey[900],
          style: const TextStyle(color: Colors.white),
          items: [
            const DropdownMenuItem<WorkoutType?>(
              value: null,
              child: Text('Todos'),
            ),
            ...WorkoutType.values.map((type) {
              return DropdownMenuItem<WorkoutType>(
                value: type,
                child: Text(_getWorkoutTypeName(type)),
              );
            }),
          ],
          onChanged: (WorkoutType? newValue) {
            setState(() {
              _selectedType = newValue;
            });
            _filterWorkouts();
          },
        ),
      ),
    );
  }

  Widget _buildDifficultyFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedDifficulty,
          dropdownColor: Colors.grey[900],
          style: const TextStyle(color: Colors.white),
          items: [
            'Todos',
            'Iniciante',
            'Intermediário',
            'Avançado',
          ].map((difficulty) {
            return DropdownMenuItem<String>(
              value: difficulty,
              child: Text(difficulty),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedDifficulty = newValue;
              });
              _filterWorkouts();
            }
          },
        ),
      ),
    );
  }

  Widget _buildEquipmentFilter() {
    return BlocBuilder<EquipmentBloc, EquipmentState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const CircularProgressIndicator();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[800]!),
          ),
          child: PopupMenuButton<String>(
            initialValue: null,
            onSelected: (String equipmentId) {
              setState(() {
                if (_selectedEquipment.contains(equipmentId)) {
                  _selectedEquipment.remove(equipmentId);
                } else {
                  _selectedEquipment.add(equipmentId);
                }
              });
              _filterWorkouts();
            },
            itemBuilder: (BuildContext context) {
              return state.equipment.map((equipment) {
                return PopupMenuItem<String>(
                  value: equipment.id,
                  child: Row(
                    children: [
                      Icon(
                        _selectedEquipment.contains(equipment.id)
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        equipment.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                );
              }).toList();
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.fitness_center, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  _selectedEquipment.isEmpty
                      ? 'Equipamentos'
                      : '${_selectedEquipment.length} selecionados',
                  style: const TextStyle(color: Colors.white),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }

  void _useTemplate(Workout template) {
    final userId = context.read<AuthBloc>().currentUserId;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not authenticated')),
      );
      return;
    }

    // Create a new workout from the template
    final workout = template.copyWith(
      id: DateTime.now().toString(),
      userId: userId,
      isTemplate: false,
      createdAt: DateTime.now(),
    );

    // Navigate to execute workout screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExecuteWorkoutScreen(workout: workout),
      ),
    );
  }

  String _getWorkoutTypeName(WorkoutType type) {
    switch (type) {
      case WorkoutType.strength:
        return 'Força';
      case WorkoutType.hypertrophy:
        return 'Hipertrofia';
      case WorkoutType.endurance:
        return 'Resistência';
      case WorkoutType.cardio:
        return 'Cardio';
      case WorkoutType.flexibility:
        return 'Flexibilidade';
      case WorkoutType.circuit:
        return 'Circuito';
      case WorkoutType.hiit:
        return 'HIIT';
    }
  }
}

class _WorkoutTemplateCard extends StatelessWidget {
  final Workout workout;
  final VoidCallback onUse;

  const _WorkoutTemplateCard({
    required this.workout,
    required this.onUse,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue..withValues(alpha: (0.3))),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withValues(alpha: (0.2)),
                  Colors.transparent,
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: (0.2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.fitness_center,
                    color: Colors.blue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workout.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${workout.exercises.length} exercícios • ${workout.estimatedDuration ~/ 60} min',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(workout.difficulty)
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    workout.difficulty,
                    style: TextStyle(
                      color: _getDifficultyColor(workout.difficulty),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTargetMuscles(),
                const SizedBox(height: 16),
                _buildRequiredEquipment(),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onUse,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Usar Template',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetMuscles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Músculos Trabalhados',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: workout.targetMuscles.map((muscle) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: (0.2)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                muscle,
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRequiredEquipment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Equipamentos Necessários',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: workout.requiredEquipment.map((equipment) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: (0.2)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                equipment,
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'iniciante':
        return Colors.green;
      case 'intermediário':
        return Colors.orange;
      case 'avançado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
