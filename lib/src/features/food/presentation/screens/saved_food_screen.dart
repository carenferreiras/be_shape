// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class SavedFoodFormScreen extends StatefulWidget {
  const SavedFoodFormScreen({super.key});

  @override
  State<SavedFoodFormScreen> createState() => _SavedFoodFormScreenState();
}

class _SavedFoodFormScreenState extends State<SavedFoodFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _servingSizeController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinsController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatsController = TextEditingController();
  String _selectedUnit = 'g';
  bool _isPublic = false;
  File? _imageFile;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await showDialog<XFile>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Choose Image Source',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.white),
                title: const Text(
                  'Camera',
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
                  'Gallery',
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

  Future<String?> _uploadImage() async {
    if (_imageFile == null) return null;

    setState(() {
      _isUploading = true;
    });

    try {
      final userId = context.read<AuthRepository>().currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = FirebaseStorage.instance
          .ref()
          .child('food_photos')
          .child(userId)
          .child(fileName);

      await ref.putFile(_imageFile!);
      final url = await ref.getDownloadURL();

      setState(() {
        _isUploading = false;
      });

      return url;
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
      return null;
    }
  }

  Future<void> _submitFood() async {
    if (_formKey.currentState!.validate()) {
      final userId = context.read<AuthRepository>().currentUser?.uid;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated')),
        );
        return;
      }

      String? photoUrl;
      if (_imageFile != null) {
        photoUrl = await _uploadImage();
      }

      final savedFood = SavedFood(
        id: DateTime.now().toString(),
        userId: userId,
        name: _nameController.text,
        calories: double.parse(_caloriesController.text),
        proteins: double.parse(_proteinsController.text),
        carbs: double.parse(_carbsController.text),
        fats: double.parse(_fatsController.text),
        brand: _brandController.text.isEmpty ? null : _brandController.text,
        servingSize: _servingSizeController.text.isEmpty ? null : _servingSizeController.text,
        servingUnit: _selectedUnit,
        isPublic: _isPublic,
        photoUrl: photoUrl,
      );

      context.read<SavedFoodBloc>().add(AddSavedFood(savedFood));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: BeShapeAppBar(
        title: 'Adicionar Alimento',
        actionIcon: Icons.food_bank,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey[800]!,
                      width: 2,
                    ),
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
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
                            const SizedBox(height: 8),
                            Text(
                              'Add Food Photo',
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
                  'Food Name',
                  Icons.restaurant_menu,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a food name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _brandController,
                style: const TextStyle(color: Colors.white),
                decoration: _buildInputDecoration(
                  'Brand (optional)',
                  Icons.business,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _servingSizeController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      decoration: _buildInputDecoration(
                        'Serving Size',
                        Icons.scale,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildUnitSelector(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _NutritionCard(
                caloriesController: _caloriesController,
                proteinsController: _proteinsController,
                carbsController: _carbsController,
                fatsController: _fatsController,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text(
                  'Make Public',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  'Allow other users to see and use this food',
                  style: TextStyle(color: Colors.grey),
                ),
                value: _isPublic,
                onChanged: (bool value) {
                  setState(() {
                    _isPublic = value;
                  });
                },
                activeColor: BeShapeColors.primary,
              ),
              const SizedBox(height: 24),
              BeShapeCustomButton(label: 'Salvar Alimento', 
              icon: Icons.save,
              isLoading: _isUploading,
              onPressed:  _isUploading ? null : _submitFood,)
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnitSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedUnit,
          dropdownColor: Colors.grey[900],
          style: const TextStyle(color: Colors.white),
          items: ['g', 'ml', 'oz', 'cup'].map((String unit) {
            return DropdownMenuItem<String>(
              value: unit,
              child: Text(unit),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedUnit = newValue;
              });
            }
          },
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
      fillColor: Colors.grey[900],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _servingSizeController.dispose();
    _caloriesController.dispose();
    _proteinsController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    super.dispose();
  }
}

class _NutritionCard extends StatelessWidget {
  final TextEditingController caloriesController;
  final TextEditingController proteinsController;
  final TextEditingController carbsController;
  final TextEditingController fatsController;

  const _NutritionCard({
    required this.caloriesController,
    required this.proteinsController,
    required this.carbsController,
    required this.fatsController,
  });

  @override
  Widget build(BuildContext context) {
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
            'Nutrition Facts',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildNutritionInput(
            'Calories',
            caloriesController,
            BeShapeColors.primary,
            'kcal',
          ),
          const SizedBox(height: 12),
          _buildNutritionInput(
            'Protein',
            proteinsController,
            BeShapeColors.link,
            'g',
          ),
          const SizedBox(height: 12),
          _buildNutritionInput(
            'Carbs',
            carbsController,
            BeShapeColors.accent,
            'g',
          ),
          const SizedBox(height: 12),
          _buildNutritionInput(
            'Fat',
            fatsController,
            Colors.red,
            'g',
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionInput(
    String label,
    TextEditingController controller,
    Color color,
    String unit,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            style: TextStyle(color: color),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              suffix: Text(
                unit,
                style: const TextStyle(color: Colors.grey),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: color.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: color),
              ),
              filled: true,
              fillColor: color.withOpacity(0.1),
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
    );
  }
}