// ignore_for_file: prefer_const_constructors

import 'package:be_shape_app/src/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features.dart';


class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen({super.key});

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

  void _submitExercise() {
  if (_formKey.currentState!.validate()) {
    final userId = context.read<AuthRepository>().currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not authenticated'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final exercise = Exercise(
      id: DateTime.now().toIso8601String(),
      userId: userId,
      name: _nameController.text,
      type: _selectedType,
      duration: int.parse(_durationController.text),
      caloriesBurned: double.parse(_caloriesController.text),
      date: _selectedDate,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );

    context.read<ExerciseBloc>().add(AddExercise(exercise));
    Navigator.pushNamed(context, '/exercises-list');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: BeShapeAppBar(title: 'Add Exercise',actionIcon: Icons.fitness_center,),
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
                            primary: BeShapeColors.primary,
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
                              color: BeShapeColors.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.calendar_today,
                              color: BeShapeColors.primary,
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
                      const Icon(Icons.arrow_drop_down, color: BeShapeColors.primary),
                    ],
                  ),
                ),
              ),
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
                                    ? BeShapeColors.primary.withOpacity(0.2)
                                    : Colors.grey[800],
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected ? BeShapeColors.primary : Colors.transparent,
                                ),
                              ),
                              child: Text(
                                type,
                                style: TextStyle(
                                  color: isSelected ? BeShapeColors.primary : Colors.grey,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
              ElevatedButton(
                onPressed: _submitExercise,
                style: ElevatedButton.styleFrom(
                  backgroundColor: BeShapeColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Exercise',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: BeShapeColors.background
                  ),
                ),
              ),
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
        borderSide: const BorderSide(color: BeShapeColors.primary),
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
}