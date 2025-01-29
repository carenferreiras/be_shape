// ignore_for_file: use_build_context_synchronously, avoid_function_literals_in_foreach_calls

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class AddProgressPhotoScreen extends StatefulWidget {
  const AddProgressPhotoScreen({super.key});

  @override
  State<AddProgressPhotoScreen> createState() => _AddProgressPhotoScreenState();
}

class _AddProgressPhotoScreenState extends State<AddProgressPhotoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedType = 'front';
  String? _photoPath;
  DateTime _selectedDate = DateTime.now();
  bool _isSubmitting = false;

  final Map<String, TextEditingController> _measurementControllers = {
    'chest': TextEditingController(),
    'waist': TextEditingController(),
    'hips': TextEditingController(),
    'biceps': TextEditingController(),
    'thighs': TextEditingController(),
  };

  Future<void> _takePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await showDialog<XFile>(
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

    if (photo != null) {
      setState(() {
        _photoPath = photo.path;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitPhoto() async {
    if (_formKey.currentState!.validate() && _photoPath != null) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        final userId = context.read<AuthRepository>().currentUser?.uid;
        if (userId == null) {
          throw Exception('User not authenticated');
        }

        final measurements = <String, double>{};
        _measurementControllers.forEach((key, controller) {
          if (controller.text.isNotEmpty) {
            measurements[key] = double.parse(controller.text);
          }
        });

        final photo = ProgressPhoto(
          id: DateTime.now().toString(),
          userId: userId,
          photoUrl: '',
          date: _selectedDate,
          type: _selectedType,
          weight: double.parse(_weightController.text),
          measurements: measurements,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
        );

        context.read<ProgressPhotoBloc>().add(AddPhoto(_photoPath!, photo));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Add Progress Photo'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _takePhoto,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey[800]!,
                      width: 2,
                    ),
                  ),
                  child: _photoPath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.file(
                            File(_photoPath!),
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 64,
                              color: Colors.grey[700],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Take Progress Photo',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('MMMM d, y').format(_selectedDate),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const Icon(
                        Icons.calendar_today,
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Photo Type',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildTypeOption('front', 'Front View'),
                        const SizedBox(width: 8),
                        _buildTypeOption('side', 'Side View'),
                        const SizedBox(width: 8),
                        _buildTypeOption('back', 'Back View'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Measurements',
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
                          child: TextFormField(
                            controller: _weightController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.number,
                            decoration: _buildInputDecoration(
                              'Weight (kg)',
                              Icons.monitor_weight,
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
                    Row(
                      children: [
                        Expanded(
                          child: _buildMeasurementField(
                            'chest',
                            'Chest',
                            Icons.straighten,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildMeasurementField(
                            'waist',
                            'Waist',
                            Icons.straighten,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMeasurementField(
                            'hips',
                            'Hips',
                            Icons.straighten,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildMeasurementField(
                            'biceps',
                            'Biceps',
                            Icons.straighten,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildMeasurementField(
                            'thighs',
                            'Thighs',
                            Icons.straighten,
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Add notes about your progress...',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[800]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[800]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.orange),
                        ),
                        filled: true,
                        fillColor: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitPhoto,
                style: ElevatedButton.styleFrom(
                  backgroundColor: BeShapeColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Save Progress',
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

  Widget _buildTypeOption(String type, String label) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedType = type;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? BeShapeColors.primary.withOpacity(0.2) : Colors.grey[800],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? BeShapeColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? BeShapeColors.primary : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMeasurementField(String key, String label, IconData icon) {
    return TextFormField(
      controller: _measurementControllers[key],
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.number,
      decoration: _buildInputDecoration(
        '$label (cm)',
        icon,
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
        borderSide: const BorderSide(color: Colors.orange),
      ),
      filled: true,
      fillColor: Colors.grey[800],
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _notesController.dispose();
    _measurementControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }
}