import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../habit.dart';

class AddHabitScreen extends StatefulWidget {
  final String selectedDate;

  const AddHabitScreen({super.key, required this.selectedDate});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  String _habitTitle = "";
  int _initialProgress = 0;
  HabitCategory? _selectedCategory;
  final List<HabitCategory> habitCategories = [
    HabitCategory(
        name: "Health", color: Colors.green, icon: Icons.health_and_safety),
    HabitCategory(name: "Work", color: Colors.blue, icon: Icons.work),
    HabitCategory(
        name: "Leisure", color: Colors.orange, icon: Icons.sports_esports),
    HabitCategory(
        name: "Fitness", color: Colors.red, icon: Icons.fitness_center),
  ];
  void _saveHabit() {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      _formKey.currentState!.save();

      final newHabit = Habit(
        title: _habitTitle,
        progress: _initialProgress,
        category: _selectedCategory!,
        date: widget.selectedDate,
      );

      context.read<HabitBloc>().add(AddHabitEvent(newHabit));

      Navigator.pop(context);
    } else if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a category")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BeShapeColors.background,
      appBar: const BeShapeAppBar(
        title: 'Hábitos',
        actionIcon: Icons.fitness_center,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BeShapeCustomTextField(
                icon: Icons.free_breakfast,
                labelText: 'Habit Title',
                hintText: '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a title for the habit";
                  }
                  return null;
                },
                onSaved: (value) => _habitTitle = value!,
              ),
              // TextFormField(
              //   decoration: const InputDecoration(
              //     labelText: "Habit Title",
              //     border: OutlineInputBorder(),
              //   ),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return "Please enter a title for the habit";
              //     }
              //     return null;
              //   },
              //   onSaved: (value) => _habitTitle = value!,
              // ),
              const SizedBox(height: 16),
              BeShapeCustomTextField(
                icon: Icons.percent,
                labelText: 'Initial Progress (%)',
                hintText: '',
                validator: (value) {
                  final parsedValue = int.tryParse(value ?? "0") ?? -1;
                  if (parsedValue < 0 || parsedValue > 100) {
                    return "Enter a value between 0 and 100";
                  }
                  return null;
                },
                onSaved: (value) {
                  _initialProgress = int.tryParse(value ?? "0") ?? 0;
                },
              ),
              // TextFormField(
              //   decoration: const InputDecoration(
              //     labelText: "Initial Progress (%)",
              //     border: OutlineInputBorder(),
              //   ),
              //   keyboardType: TextInputType.number,
              //   validator: (value) {
              //     final parsedValue = int.tryParse(value ?? "0") ?? -1;
              //     if (parsedValue < 0 || parsedValue > 100) {
              //       return "Enter a value between 0 and 100";
              //     }
              //     return null;
              //   },
              //   onSaved: (value) {
              //     _initialProgress = int.tryParse(value ?? "0") ?? 0;
              //   },
              // ),
              const SizedBox(height: 16),
              DropdownButtonFormField<HabitCategory>(
                decoration: InputDecoration(
                  labelText: 'Categoria',
                  labelStyle: const TextStyle(color: Colors.grey),
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon:
                      const Icon(Icons.category, color: BeShapeColors.primary),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: BeShapeColors.primary),
                    borderRadius:
                        BorderRadius.circular(BeShapeSizes.borderRadiusLarge),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: BeShapeColors.primary),
                    borderRadius:
                        BorderRadius.circular(BeShapeSizes.borderRadiusLarge),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF1C1C1E), // Fundo do campo
                ),
                items: habitCategories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Row(
                      children: [
                        Icon(category.icon, color: category.color),
                        const SizedBox(width: 8),
                        Text(category.name),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) =>
                    value == null ? "Please select a category" : null,
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _saveHabit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6367F0),
                  ),
                  child: const Text("Save Habit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
