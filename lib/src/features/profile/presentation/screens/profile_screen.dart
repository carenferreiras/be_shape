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
  UserProfile? _userProfile;
  bool _isEditing = false;
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _targetWeightController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();
  String? _profileImageUrl; // URL da imagem de perfil

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final userId = context.read<AuthRepository>().currentUser?.uid;
    if (userId != null) {
      final profile =
          await context.read<UserRepository>().getUserProfile(userId);
      if (profile != null) {
        setState(() {
          _userProfile = profile;
          _profileImageUrl = profile.measurements["profileImageUrl"]
              as String?; // URL da imagem
          _weightController.text = profile.weight.toString();
          _targetWeightController.text = profile.targetWeight.toString();
          _goalController.text = profile.goal;
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
        goal: _goalController.text,
      );

      await context.read<UserRepository>().updateUserProfile(updatedProfile);
      setState(() {
        _userProfile = updatedProfile;
        _isEditing = false;
      });
    }
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
            fit: BoxFit.cover
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 150,),
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
                goalController: _goalController,
                userProfile: _userProfile,),
              const SizedBox(height: 24),
              // _buildMacroTargets(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BuildCard(
                      icon: Icons.fitness_center,
                      boldTitle: macros.proteins.round().toString(),
                      title: 'Proteínas',
                      color: Colors.blue),
                  BuildCard(
                      icon: Icons.grain,
                      boldTitle: macros.carbs.round().toString(),
                      title: 'Carboidratos',
                      color: Colors.green),
                  BuildCard(
                      icon: Icons.opacity,
                      boldTitle: macros.carbs.round().toString(),
                      title: 'Gordura',
                      color: BeShapeColors.primary)
                ],
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
  @override
  void dispose() {
    _weightController.dispose();
    _targetWeightController.dispose();
    _goalController.dispose();
    super.dispose();
  }
}
