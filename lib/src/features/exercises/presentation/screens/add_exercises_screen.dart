// ignore_for_file: prefer_const_constructors

import 'package:be_shape_app/src/core/core.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features.dart';

class AddExerciseScreen extends StatefulWidget {
  final Equipment? selectedEquipment;

  const AddExerciseScreen({
    super.key,
    this.selectedEquipment,
  });

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedType = 'Cardio';
  DateTime _selectedDate = DateTime.now();

  final List<String> _exerciseTypes = [
    'Cardio',
    'Strength',
    'Flexibility',
    'Sports',
    'Other'
  ];

  List<Equipment> _equipmentList = [];
  List<String> _selectedEquipmentIds = [];
  List<String> _muscleGroups = [];
  List<String> _exercises = [];

  @override
  void initState() {
    super.initState();
    _loadUserEquipment();
  }

  void _loadUserEquipment() {
    final userId = context.read<AuthBloc>().currentUserId;
    if (userId != null) {
      context.read<EquipmentBloc>().add(LoadUserEquipment(userId));
    }
  }

  void _updateExerciseDetails() {
    final selectedEquipments =
        _equipmentList.where((e) => _selectedEquipmentIds.contains(e.id));

    setState(() {
      _muscleGroups =
          selectedEquipments.expand((e) => e.muscleGroups).toSet().toList();
      _exercises =
          selectedEquipments.expand((e) => e.exercises).toSet().toList();
    });
  }

  void _submitExercise() {
    if (_formKey.currentState!.validate()) {
      final userId = context.read<AuthBloc>().currentUserId;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated')),
        );
        return;
      }

      final selectedEquipmentNames = _equipmentList
          .where((e) => _selectedEquipmentIds.contains(e.id))
          .map((e) => e.name)
          .toList();

      final exercise = Exercise(
        id: DateTime.now().toString(),
        userId: userId,
        name: _nameController.text,
        type: _selectedType,
        duration: int.parse(_durationController.text),
        caloriesBurned: double.parse(_caloriesController.text),
        date: _selectedDate,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        equipmentIds: _selectedEquipmentIds,
        equipmentNames: selectedEquipmentNames,
      );

      context.read<ExerciseBloc>().add(AddExercise(exercise));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: BeShapeAppBar(
        title: 'Adicionar Exercício',
        actionIcon: Icons.fitness_center,
      ),
      // appBar: AppBar(
      //   title: const Text('Add Exercise', style: TextStyle(color: Colors.white)),
      //   backgroundColor: Colors.black,
      //   elevation: 2,
      //   actions: [
      //     TextButton.icon(
      //       onPressed: () {
      //         Navigator.pushNamed(context, '/equipment');
      //       },
      //       icon: const Icon(Icons.fitness_center),
      //       label: const Text('Equipamentos'),
      //       style: TextButton.styleFrom(
      //         foregroundColor: Colors.blue,
      //       ),
      //     ),
      //   ],
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Date Selection
              InkWell(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: Colors.blue,
                            onPrimary: Colors.white,
                            surface: Color(0xFF303030),
                            onSurface: Colors.white,
                          ),
                          dialogBackgroundColor: const Color(0xFF303030),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[800]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.calendar_today,
                              color: Colors.blue,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.blue),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Equipment Selection
              // Seletor de Equipamentos (Chips)
              BlocBuilder<EquipmentBloc, EquipmentState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  _equipmentList = state.equipment;

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[800]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Equipamentos',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Card(
                              color: BeShapeColors.primary,
                              child: IconButton(
                                onPressed: () =>
                                    Navigator.pushNamed(context, '/equipment'),
                                icon: Icon(Icons.add,color: BeShapeColors.textPrimary,),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 12),
                        ChipsChoice<String>.multiple(
                          value: _selectedEquipmentIds,
                          onChanged: (val) {
                            setState(() {
                              _selectedEquipmentIds = val;
                              _updateExerciseDetails();
                            });
                          },
                          choiceItems: C2Choice.listFrom<String, Equipment>(
                            source: state.equipment,
                            value: (index, item) => item.id,
                            label: (index, item) => item.name,
                          ),
                          wrapped: true,
                          choiceStyle: C2ChipStyle.filled(
                            selectedStyle: C2ChipStyle(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Grupos Musculares
              _buildInfoSection('Grupos Musculares', _muscleGroups,
                  Icons.fitness_center, Colors.green),
              const SizedBox(height: 16),

              // Exercícios Relacionados
              _buildInfoSection('Exercícios', _exercises,
                  Icons.sports_gymnastics, Colors.orange),
              const SizedBox(height: 16),
              const SizedBox(height: 16),

              // Exercise Type Selection
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[800]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Exercise Type',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _exerciseTypes.map((type) {
                          final isSelected = type == _selectedType;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedType = type;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.blue.withOpacity(0.2)
                                    : Colors.grey[800],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.transparent,
                                ),
                              ),
                              child: Text(
                                type,
                                style: TextStyle(
                                  color: isSelected ? Colors.blue : Colors.grey,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Exercise Details
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[800]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Exercise Details',
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
                        'Exercise Name',
                        Icons.fitness_center,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an exercise name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _durationController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.number,
                            decoration: _buildInputDecoration(
                              'Duration (min)',
                              Icons.timer,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _caloriesController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.number,
                            decoration: _buildInputDecoration(
                              'Calories',
                              Icons.local_fire_department,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 3,
                      decoration: _buildInputDecoration(
                        'Notes (optional)',
                        Icons.note,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              BeShapeCustomButton(
                label: 'Salvar Exercício',
                isLoading: false,
                icon: Icons.save,
                onPressed: _submitExercise,
              )
            ],
          ),
        ),
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
        borderSide: BorderSide(color: Colors.blue),
      ),
      filled: true,
      fillColor: Colors.grey[800],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Widget _buildInfoSection(
      String title, List<String> items, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.isEmpty
                ? [
                    Text('Nenhum dado disponível',
                        style: TextStyle(color: Colors.grey))
                  ]
                : items.map((item) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item,
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
          ),
        ],
      ),
    );
  }
}
