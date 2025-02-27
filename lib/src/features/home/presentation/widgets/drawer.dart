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
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          children: [
            // Header

            const SizedBox(height: 32),

            // Profile Section
            _buildDrawerSection(
              title: 'Profile',
              items: [
                FutureBuilder(
                    future:
                        context.read<UserRepository>().getUserProfile(userId),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                            child: SpinKitWaveSpinner(
                          color: BeShapeColors.primary,
                        ));
                      }

                      final userProfile = snapshot.data!;
                      return DrawerItems(
                        icon: Icons.person,
                        title: userProfile.name,
                        subtitle: 'View Profile',
                        iconColor: BeShapeColors.link,
                        onTap: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                      );
                    }),
              ],
            ),
            _buildDrawerSection(
              title: 'Nutrition',
              items: [
                FutureBuilder(
                    future:
                        context.read<UserRepository>().getUserProfile(userId),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                            child: SpinKitWaveSpinner(
                          color: BeShapeColors.primary,
                        ));
                      }

                      final userProfile = snapshot.data!;
                      return DrawerEditItensCard(
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
                      );
                    }),
              ],
            ),
            _buildDrawerSection(
              title: 'Progresso',
              items: [
                DrawerItems(
                  icon: Icons.medication,
                  title: 'Histórico de Progressos',
                  iconColor: Colors.green,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/body-progress');
                  },
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
                  iconColor: BeShapeColors.link,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/progress-photos');
                  },
                ),
                DrawerItems(
                  icon: Icons.history,
                  title: 'Reports History',
                  iconColor: BeShapeColors.primary,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/reports');
                  },
                ),
                DrawerItems(
                  icon: Icons.restaurant_menu,
                  title: 'Daily Food Tracking',
                  iconColor: BeShapeColors.accent,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/daily-tracking');
                  },
                ),
              ],
            ),

            // Nutrition Section
            _buildDrawerSection(
              title: 'Fitness',
              items: [
                DrawerItems(
                  icon: Icons.medication,
                  title: 'Suplementos',
                  iconColor: Colors.purple,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/suplement');
                  },
                ),
               
              ],
            ),
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
              overflow: TextOverflow.ellipsis),
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
