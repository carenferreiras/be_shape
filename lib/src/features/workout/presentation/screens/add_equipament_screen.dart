import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../features.dart';

class AddEquipmentScreen extends StatefulWidget {
  final SuggestedEquipment? suggestion;

  const AddEquipmentScreen({
    super.key,
    this.suggestion,
  });

  @override
  State<AddEquipmentScreen> createState() => _AddEquipmentScreenState();
}

class _AddEquipmentScreenState extends State<AddEquipmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _muscleGroupController = TextEditingController();
  final _exerciseController = TextEditingController();
  late EquipmentCategory _selectedCategory;
  final List<String> _muscleGroups = [];
  final List<String> _exercises = [];
  File? _imageFile;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill form if suggestion is provided
    if (widget.suggestion != null) {
      _nameController.text = widget.suggestion!.name;
      _descriptionController.text = widget.suggestion!.description;
      _selectedCategory = widget.suggestion!.category;
      _muscleGroups.addAll(widget.suggestion!.muscleGroups);
      _exercises.addAll(widget.suggestion!.exercises);
    } else {
      _selectedCategory = EquipmentCategory.freeWeight;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _muscleGroupController.dispose();
    _exerciseController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await showDialog<XFile>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Escolher Imagem',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.white),
                title: const Text(
                  'Câmera',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  Navigator.pop(
                    context,
                    await picker.pickImage(source: ImageSource.camera),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.white),
                title: const Text(
                  'Galeria',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  Navigator.pop(
                    context,
                    await picker.pickImage(source: ImageSource.gallery),
                  );
                },
              ),
            ],
          ),
        );
      },
    );

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  void _addMuscleGroup() {
    final group = _muscleGroupController.text.trim();
    if (group.isNotEmpty) {
      setState(() {
        _muscleGroups.add(group);
        _muscleGroupController.clear();
      });
    }
  }

  void _removeMuscleGroup(String group) {
    setState(() {
      _muscleGroups.remove(group);
    });
  }

  void _addExercise() {
    final exercise = _exerciseController.text.trim();
    if (exercise.isNotEmpty) {
      setState(() {
        _exercises.add(exercise);
        _exerciseController.clear();
      });
    }
  }

  void _removeExercise(String exercise) {
    setState(() {
      _exercises.remove(exercise);
    });
  }

  Future<void> _submitEquipment() async {
    if (_formKey.currentState!.validate() &&
        _muscleGroups.isNotEmpty &&
        _exercises.isNotEmpty) {
      setState(() {
        _isUploading = true;
      });

      try {
        final userId = context.read<AuthBloc>().currentUserId;
        if (userId == null) {
          throw Exception('User not authenticated');
        }

        String? imageUrl;
        if (_imageFile != null) {
          // Upload image to Firebase Storage
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('equipment_images')
              .child(userId)
              .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

          await storageRef.putFile(_imageFile!);
          imageUrl = await storageRef.getDownloadURL();
        }

        final equipment = Equipment(
          id: DateTime.now().toString(),
          userId: userId,
          name: _nameController.text,
          category: _selectedCategory,
          description: _descriptionController.text,
          muscleGroups: _muscleGroups,
          exercises: _exercises,
          imageUrl: imageUrl,
        );

        context.read<EquipmentBloc>().add(AddEquipment(equipment));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Adicionar Equipamento'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey[800]!,
                      width: 2,
                    ),
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 48,
                              color: Colors.grey[700],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Adicionar Foto',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: _buildInputDecoration(
                  'Nome do Equipamento',
                  Icons.fitness_center,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do equipamento';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildCategorySelector(),
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
              const SizedBox(height: 24),
              _buildMuscleGroupsSection(),
              const SizedBox(height: 24),
              _buildExercisesSection(),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isUploading ? null : _submitEquipment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isUploading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Salvar Equipamento',
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

  Widget _buildCategorySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<EquipmentCategory>(
          value: _selectedCategory,
          dropdownColor: Colors.grey[900],
          style: const TextStyle(color: Colors.white),
          items: EquipmentCategory.values.map((category) {
            return DropdownMenuItem<EquipmentCategory>(
              value: category,
              child: Text(_getCategoryName(category)),
            );
          }).toList(),
          onChanged: (EquipmentCategory? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedCategory = newValue;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildMuscleGroupsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Grupos Musculares',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _muscleGroupController,
                style: const TextStyle(color: Colors.white),
                decoration: _buildInputDecoration(
                  'Adicionar grupo muscular',
                  Icons.accessibility_new,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _addMuscleGroup,
              icon: const Icon(Icons.add_circle),
              color: Colors.green,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _muscleGroups.map((group) {
            return Chip(
              backgroundColor: Colors.green.withOpacity(0.2),
              label: Text(
                group,
                style: const TextStyle(color: Colors.green),
              ),
              deleteIcon: const Icon(
                Icons.close,
                size: 18,
                color: Colors.green,
              ),
              onDeleted: () => _removeMuscleGroup(group),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildExercisesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Exercícios',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _exerciseController,
                style: const TextStyle(color: Colors.white),
                decoration: _buildInputDecoration(
                  'Adicionar exercício',
                  Icons.sports_gymnastics,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _addExercise,
              icon: const Icon(Icons.add_circle),
              color: Colors.orange,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _exercises.map((exercise) {
            return Chip(
              backgroundColor: Colors.orange.withOpacity(0.2),
              label: Text(
                exercise,
                style: const TextStyle(color: Colors.orange),
              ),
              deleteIcon: const Icon(
                Icons.close,
                size: 18,
                color: Colors.orange,
              ),
              onDeleted: () => _removeExercise(exercise),
            );
          }).toList(),
        ),
      ],
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
      fillColor: Colors.grey[900],
    );
  }

  String _getCategoryName(EquipmentCategory category) {
    switch (category) {
      case EquipmentCategory.freeWeight:
        return 'Peso Livre';
      case EquipmentCategory.resistance:
        return 'Resistência';
      case EquipmentCategory.cardio:
        return 'Cardio';
      case EquipmentCategory.calisthenics:
        return 'Calistenia';
      case EquipmentCategory.machine:
        return 'Máquinas';
      case EquipmentCategory.recovery:
        return 'Recuperação';
      case EquipmentCategory.explosive:
        return 'Explosão';
      case EquipmentCategory.cable:
        return 'Cabos';
      case EquipmentCategory.bodyweight:
        return 'Peso';
      case EquipmentCategory.functional:
        return 'Funcional';
      case EquipmentCategory.accessory:
        return 'Acessório';
    }
  }
}