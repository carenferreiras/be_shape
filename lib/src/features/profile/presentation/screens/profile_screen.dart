// ignore_for_file: unused_local_variable

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  double? _initialTDEE;
  MacroTargets? _initialMacroTargets;
  UserProfile? _userProfile;
  bool _isEditing = false;
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _targetWeightController = TextEditingController();

  String? _selectedGoal;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
  final userId = context.read<AuthRepository>().currentUser?.uid;
  if (userId != null) {
    final profile = await context.read<UserRepository>().getUserProfile(userId);
    if (profile != null) {
      setState(() {
        _userProfile = profile;
        _profileImageUrl = profile.profileImageUrl;
        _weightController.text = profile.weight.toString();
        _targetWeightController.text = profile.targetWeight.toString();
        _selectedGoal = profile.goal;

        // 🔹 Salva os valores iniciais na primeira vez
        _initialTDEE ??= profile.tdee;
        _initialMacroTargets ??= profile.macroTargets;
      });
    }
  }
}

  Future<void> _updateProfileImage() async {
    final userId = context.read<AuthRepository>().currentUser?.uid;
    if (userId == null) return;

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final fileBytes = await pickedFile.readAsBytes();

        final storageRef =
            FirebaseStorage.instance.ref().child('profile_images/$userId.jpg');

        await storageRef.putData(fileBytes);

        final imageUrl = await storageRef.getDownloadURL();

        final updatedProfile =
            _userProfile!.copyWith(profileImageUrl: imageUrl);

        await context.read<UserRepository>().updateUserProfile(updatedProfile);

        setState(() {
          _userProfile = updatedProfile;
          _profileImageUrl = imageUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Imagem de perfil atualizada!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao atualizar a imagem de perfil")),
      );
    }
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _saveProfileChanges() async {
    if (_userProfile == null) return;
    final userId = context.read<AuthRepository>().currentUser?.uid;
    if (userId != null) {
      final updatedProfile = _userProfile!.copyWith(
        weight: double.tryParse(_weightController.text) ?? _userProfile!.weight,
        targetWeight: double.tryParse(_targetWeightController.text) ??
            _userProfile!.targetWeight,
        goal: _selectedGoal ?? _userProfile!.goal,
      );

      await context.read<UserRepository>().updateUserProfile(updatedProfile);
      setState(() {
        _userProfile = updatedProfile;
        _isEditing = false;
      });
    }
  }

  void _onGoalChanged(String? newGoal) {
  if (newGoal == null || _userProfile == null) return;

  setState(() {
    _selectedGoal = newGoal;

    double adjustedTDEE;
    MacroTargets updatedMacroTargets;

    switch (newGoal) {
      case 'lose_weight':
        adjustedTDEE = _initialTDEE! - 500; // Déficit para perda de peso
        break;
      case 'bulk':
        adjustedTDEE = _initialTDEE! + 500; // Superávit para ganho de massa
        break;
      case 'endurance':
        adjustedTDEE = _initialTDEE!; // Mantém o TDEE original
        break;
      case 'try_out': // 🔹 Se escolher "continuar normalmente", volta aos valores iniciais
      case 'ai_coach':
      default:
        adjustedTDEE = _initialTDEE!;
    }

    // 🔹 Se for "continuar normalmente", volta aos valores iniciais de macro
    updatedMacroTargets = (newGoal == 'try_out' || newGoal == 'ai_coach')
        ? _initialMacroTargets!
        : MacroTargets.fromTDEE(adjustedTDEE, _userProfile!.weight);

    _userProfile = _userProfile!.copyWith(
      goal: newGoal,
      tdee: adjustedTDEE,
      macroTargets: updatedMacroTargets,
    );
  });
}

  @override
  Widget build(BuildContext context) {
    if (_userProfile == null) {
      return const Center(
          child: SpinKitThreeBounce(color: BeShapeColors.primary));
    }
    final macros = _userProfile!.macroTargets;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: BeShapeAppBar(
        hasLeading: false,
        appBarColor: Colors.transparent,
        actionIcon: _isEditing ? Icons.check : Icons.edit,
        actionIconPressed: _isEditing ? _saveProfileChanges : _toggleEdit,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(BeShapeImages.profileBackground),
              fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                height: 150,
              ),
              ProfileHeader(
                onTap: _updateProfileImage,
                image: _profileImageUrl,
                userProfile: _userProfile,
              ),
              const SizedBox(height: 24),
              ProfileDetails(
                isEditing: _isEditing,
                weightController: _weightController,
                targetWeightController: _targetWeightController,
                goalDropdown: _buildGoalDropdown(),
                userProfile: _userProfile!,
              ),
              const SizedBox(height: 24),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BuildCard(
                        icon: Icons.fitness_center,
                        boldTitle: _userProfile!.macroTargets.proteins.round().toString(), // 🔹 Atualizado dinamicamente
                        title: 'Proteínas',
                        color: Colors.blue),
                    BuildCard(
                        icon: Icons.grain,
                        boldTitle: _userProfile!.macroTargets.carbs.round().toString(),
                        title: 'Carboidratos',
                        color: Colors.green),
                    BuildCard(
                        icon: Icons.opacity,
                        boldTitle: _userProfile!.macroTargets.fats.round().toString(),
                        title: 'Gordura',
                        color: BeShapeColors.primary)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BeShapeNavigatorBar(
        index: 3,
      ),
    );
  }

  Widget _buildGoalDropdown() {
    List<Map<String, String>> goalOptions = [
      {'value': 'lose_weight', 'label': 'Eu quero perder Peso'},
      {'value': 'ai_coach', 'label': 'I wanna try AI Coach'},
      {'value': 'bulk', 'label': 'Eu quero ganhar Massa'},
      {'value': 'endurance', 'label': 'I wanna gain endurance'},
      {'value': 'try_out', 'label': 'Just trying out the app! 👍'},
    ];

    return _isEditing
        ? DropdownButtonFormField<String>(
            value: _selectedGoal,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: BeShapeColors.primary),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            items: goalOptions.map((goal) {
              return DropdownMenuItem<String>(
                value: goal['value'],
                child: Text(goal['label']!,
                    style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: _onGoalChanged, // 🔹 Atualiza os valores imediatamente
            dropdownColor: Colors.black,
          )
        : Text(
            goalOptions.firstWhere((goal) => goal['value'] == _selectedGoal,
                orElse: () => {'label': 'Not set'})['label']!,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
          );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }
}
