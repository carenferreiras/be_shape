import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class BeShapeDrawer extends StatelessWidget {
  final String userId;
  const BeShapeDrawer({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: FutureBuilder<UserProfile?>(
        future: context.read<UserRepository>().getUserProfile(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: SpinKitThreeBounce(color: BeShapeColors.primary,));
          }

          final userProfile = snapshot.data!;

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      BeShapeImages.beShape,
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 30,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Profile Section
                _buildDrawerSection(
                  title: 'Profile',
                  items: [
                    DrawerItems(
                      icon: Icons.person,
                      title: userProfile.name,
                      subtitle: 'View Profile',
                      iconColor: Colors.blue,
                      onTap: () {
                        Navigator.pushNamed(context, '/profile');
                      },
                    ),
                  ],
                ),
                _buildDrawerSection(
                  title: 'Nutrition',
                  items: [
                    DrawerEditItensCard(
                      protein: '${userProfile.macroTargets.proteins.round()}',
                      proteinDialogOnTap: () => _showMacroTargetDialog(
                        context,
                        'Protein',
                        userProfile.macroTargets.proteins,
                        userProfile,
                      ),
                      carbs: '${userProfile.macroTargets.carbs.round()}',
                      carbsDialogOnTap: () => _showMacroTargetDialog(
                        context,
                        'Carbs',
                        userProfile.macroTargets.carbs,
                        userProfile,
                      ),
                      fat: '${userProfile.macroTargets.fats.round()}',
                      fatDialogOnTap: () => _showMacroTargetDialog(
                        context,
                        'Fat',
                        userProfile.macroTargets.fats,
                        userProfile,
                      ),
                      tdee: '${userProfile.tdee.round()}',
                      tdeeRecalculateOnTap: () =>
                          () => _recalculateMacros(context, userProfile),
                    ),
                  ],
                ),
                // Tracking Section
                _buildDrawerSection(
                  title: 'Tracking',
                  items: [
                    DrawerItems(
                      icon: Icons.photo_library,
                      title: 'Progress Photos',
                      iconColor: Colors.purple,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/progress-photos');
                      },
                    ),
                    DrawerItems(
                      icon: Icons.history,
                      title: 'Reports History',
                      iconColor: Colors.orange,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/reports');
                      },
                    ),
                    DrawerItems(
                      icon: Icons.restaurant_menu,
                      title: 'Daily Food Tracking',
                      iconColor: Colors.green,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/daily-tracking');
                      },
                    ),
                  ],
                ),

                // Nutrition Section

                const SizedBox(height: 24),
                const Divider(color: Colors.grey),
                const SizedBox(height: 24),

                // Danger Zone
                _buildDrawerSection(
                  title: 'Danger Zone',
                  titleColor: Colors.red,
                  items: [
                    DrawerItems(
                      icon: Icons.logout,
                      title: 'Sign Out',
                      iconColor: Colors.red,
                      onTap: () async {
                        try {
                          await context.read<AuthRepository>().signOut();
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(context, '/login');
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error logging out: $e')),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrawerSection({
    required String title,
    required List<Widget> items,
    Color titleColor = Colors.grey,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.ellipsis
          ),
        ),
        const SizedBox(height: 12),
        ...items,
        const SizedBox(height: 24),
      ],
    );
  }

  Future<void> _showMacroTargetDialog(
    BuildContext context,
    String macro,
    double currentValue,
    UserProfile userProfile,
  ) async {
    final controller =
        TextEditingController(text: currentValue.round().toString());

    return showDialog(
        context: context,
        builder: (context) => MacroTargetDialog(
            context: context,
            macro: macro,
            currentValue: currentValue,
            controller: controller,
            userProfile: userProfile));
  }

  Future<void> _recalculateMacros(
    BuildContext context,
    UserProfile userProfile,
  ) async {
    final newMacros = MacroTargets.fromTDEE(
      userProfile.tdee,
      userProfile.weight,
    );

    final updatedProfile = userProfile.copyWith(macroTargets: newMacros);

    await context.read<UserRepository>().updateUserProfile(updatedProfile);

    if (context.mounted) {
      // Refresh the screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }
}
