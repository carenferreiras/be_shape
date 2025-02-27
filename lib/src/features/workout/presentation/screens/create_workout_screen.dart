import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features.dart';

class CreateWorkoutScreen extends StatefulWidget {
  final Equipment? equipment;

  const CreateWorkoutScreen({
    super.key,
    this.equipment,
  });

  @override
  State<CreateWorkoutScreen> createState() => _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends State<CreateWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _exerciseNameController = TextEditingController();
  final _exerciseNotesController = TextEditingController();
  final _exerciseTipsController = TextEditingController();
  final _exerciseRestController = TextEditingController(text: '60');
  final _exerciseRepsController = TextEditingController(text: '12');
  final _exerciseSetsController = TextEditingController(text: '3');
  WorkoutType _selectedType = WorkoutType.strength;
  String _selectedDifficulty = 'Iniciante';
  int _restBetweenSets = 60;
  final List<String> _targetMuscles = [];
  final List<String> _requiredEquipment = [];
  final List<WorkoutExercise> _exercises = [];
  bool _isTemplate = false;

  @override
  void initState() {
    super.initState();
    if (widget.equipment != null) {
      setState(() {
        _requiredEquipment.add(widget.equipment!.name);
        _targetMuscles.addAll(widget.equipment!.muscleGroups);
      });
    }
  }

  void _addExercise() {
    if (_exerciseNameController.text.isEmpty) return;

    final sets = <ExerciseSet>[];
    final setsCount = int.tryParse(_exerciseSetsController.text) ?? 3;
    final reps = int.tryParse(_exerciseRepsController.text) ?? 12;

    for (var i = 0; i < setsCount; i++) {
      sets.add(ExerciseSet(
        reps: reps,
        order: i,
      ));
    }

    final exercise = WorkoutExercise(
      id: DateTime.now().toString(),
      name: _exerciseNameController.text,
      equipment: _requiredEquipment.first,
      muscleGroups: _targetMuscles,
      sets: sets,
      notes: _exerciseNotesController.text.isEmpty
          ? null
          : _exerciseNotesController.text,
      tips: _exerciseTipsController.text.isEmpty
          ? null
          : _exerciseTipsController.text.split('\n'),
      restTime: int.tryParse(_exerciseRestController.text) ?? 60,
      order: _exercises.length,
    );

    setState(() {
      _exercises.add(exercise);
      _exerciseNameController.clear();
      _exerciseNotesController.clear();
      _exerciseTipsController.clear();
      _exerciseRestController.text = '60';
      _exerciseRepsController.text = '12';
      _exerciseSetsController.text = '3';
    });
  }

  void _removeExercise(int index) {
    setState(() {
      _exercises.removeAt(index);
      // Update order for remaining exercises
      for (var i = 0; i < _exercises.length; i++) {
        _exercises[i] = _exercises[i].copyWith(order: i);
      }
    });
  }

  void _submitWorkout() {
    if (_formKey.currentState!.validate() && _exercises.isNotEmpty) {
      final userId = context.read<AuthBloc>().currentUserId;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated')),
        );
        return;
      }

      final workout = Workout(
        id: DateTime.now().toString(),
        userId: userId,
        name: _nameController.text,
        type: _selectedType,
        description: _descriptionController.text,
        exercises: _exercises,
        restBetweenSets: _restBetweenSets,
        estimatedDuration: _calculateEstimatedDuration(),
        createdAt: DateTime.now(),
        requiredEquipment: _requiredEquipment,
        difficulty: _selectedDifficulty,
        targetMuscles: _targetMuscles,
        isTemplate: _isTemplate,
      );

      context.read<WorkoutBloc>().add(AddWorkout(workout));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, adicione pelo menos um exercício'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  int _calculateEstimatedDuration() {
    int totalDuration = 0;
    
    // Tempo dos exercícios
    for (final exercise in _exercises) {
      final setsCount = exercise.sets.length;
      final restTime = exercise.restTime;
      
      // Tempo para cada série (estimado em 45 segundos) + descanso
      totalDuration += setsCount * (45 + restTime);
    }
    
    // Tempo de descanso entre exercícios
    totalDuration += (_exercises.length - 1) * _restBetweenSets;
    
    // Adiciona 5 minutos para aquecimento
    totalDuration += 300;
    
    return totalDuration;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _exerciseNameController.dispose();
    _exerciseNotesController.dispose();
    _exerciseTipsController.dispose();
    _exerciseRestController.dispose();
    _exerciseRepsController.dispose();
    _exerciseSetsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Criar Treino'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBasicInfo(),
              const SizedBox(height: 24),
              _buildWorkoutConfig(),
              const SizedBox(height: 24),
              _buildExercisesList(),
              const SizedBox(height: 24),
              _buildAddExercise(),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitWorkout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Salvar Treino',
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
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informações Básicas',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white),
            decoration: _buildInputDecoration(
              'Nome do Treino',
              Icons.fitness_center,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira o nome do treino';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            style: const TextStyle(color: Colors.white),
            maxLines: 3,
            decoration: _buildInputDecoration(
              'Descrição',
              Icons.description,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira uma descrição';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutConfig() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Configurações do Treino',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTypeSelector(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDifficultySelector(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRestTimeSelector(),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text(
              'Salvar como Template',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              'Disponibilizar para outros usuários',
              style: TextStyle(color: Colors.grey[400]),
            ),
            value: _isTemplate,
            onChanged: (value) {
              setState(() {
                _isTemplate = value;
              });
            },
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[800]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<WorkoutType>(
              value: _selectedType,
              dropdownColor: Colors.grey[900],
              style: const TextStyle(color: Colors.white),
              items: WorkoutType.values.map((type) {
                return DropdownMenuItem<WorkoutType>(
                  value: type,
                  child: Text(_getWorkoutTypeName(type)),
                );
              }).toList(),
              onChanged: (WorkoutType? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedType = newValue;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dificuldade',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
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
              items: ['Iniciante', 'Intermediário', 'Avançado'].map((difficulty) {
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
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRestTimeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tempo de Descanso entre Exercícios',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: _restBetweenSets.toDouble(),
                min: 30,
                max: 180,
                divisions: 15,
                label: '${_restBetweenSets}s',
                onChanged: (value) {
                  setState(() {
                    _restBetweenSets = value.round();
                  });
                },
                activeColor: Colors.blue,
                inactiveColor: Colors.grey[800],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_restBetweenSets}s',
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExercisesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Exercícios',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (_exercises.isEmpty)
          Center(
            child: Text(
              'Nenhum exercício adicionado',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _exercises.length,
            itemBuilder: (context, index) {
              return _ExerciseCard(
                exercise: _exercises[index],
                onDelete: () => _removeExercise(index),
                onEdit: () {
                  // TODO: Implementar edição
                },
              );
            },
          ),
      ],
    );
  }

  Widget _buildAddExercise() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16), 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Adicionar Exercício',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _exerciseNameController,
            style: const TextStyle(color: Colors.white),
            decoration: _buildInputDecoration(
              'Nome do Exercício',
              Icons.sports_gymnastics,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _exerciseSetsController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: _buildInputDecoration(
                    'Séries',
                    Icons.repeat,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _exerciseRepsController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: _buildInputDecoration(
                    'Repetições',
                    Icons.fitness_center,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _exerciseRestController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            decoration: _buildInputDecoration(
              'Tempo de Descanso (segundos)',
              Icons.timer,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _exerciseNotesController,
            style: const TextStyle(color: Colors.white),
            decoration: _buildInputDecoration(
              'Notas (opcional)',
              Icons.note,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _exerciseTipsController,
            style: const TextStyle(color: Colors.white),
            maxLines: 3,
            decoration: _buildInputDecoration(
              'Dicas (uma por linha, opcional)',
              Icons.lightbulb,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _addExercise,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Exercício'),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      prefixIcon: Icon(icon, color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[800]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue),
      ),
      filled: true,
      fillColor: Colors.grey[850],
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

class _ExerciseCard extends StatelessWidget {
  final WorkoutExercise exercise;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _ExerciseCard({
    required this.exercise,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              exercise.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '${exercise.sets.length} séries • ${exercise.sets.first.reps} repetições',
              style: TextStyle(color: Colors.grey[400]),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
          if (exercise.notes != null || (exercise.tips?.isNotEmpty ?? false))
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (exercise.notes != null) ...[
                    Text(
                      'Notas:',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      exercise.notes!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                  if (exercise.tips?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Dicas:',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...exercise.tips!.map((tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              tip,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}