import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../features.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadTodayData();
  }

  void _loadTodayData() {
    final userId = context.read<AuthRepository>().currentUser?.uid;
    if (userId != null) {
      final today = DateTime.now();
      final normalizedDate = DateTime(today.year, today.month, today.day);
      context.read<MealBloc>().add(LoadMealsForDate(normalizedDate));
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthRepository>().currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.black,
      drawer: userId == null ? null : _buildDrawer(context, userId),
      body: userId == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder(
              future: context.read<UserRepository>().getUserProfile(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final userProfile = snapshot.data;
                if (userProfile == null) {
                  return const Center(child: Text('No user profile found'));
                }

                return SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Builder(
                                builder: (context) => IconButton(
                                  icon: const Icon(Icons.menu, color: Colors.white),
                                  onPressed: () => Scaffold.of(context).openDrawer(),
                                ),
                              ),
                              Expanded(child: UserHeader(userProfile: userProfile)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Today's Date
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: Colors.orange,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  DateFormat('EEEE, MMMM d').format(DateTime.now()),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          FitnessMetrics(userProfile: userProfile),
                          const SizedBox(height: 24),
                          MealCard(userProfile: userProfile),
                          const SizedBox(height: 32),
                          RecentHistory(userProfile: userProfile),
                           const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.grey[900],
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: 'Workouts',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu),
            label: 'Nutrition',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onDestinationSelected: (index) {
          switch (index) {
            case 2: // Nutrition tab
              Navigator.pushNamed(context, '/daily-tracking');
              break;
          }
        },
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, String userId) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: FutureBuilder<UserProfile?>(
        future: context.read<UserRepository>().getUserProfile(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final userProfile = snapshot.data!;
          final macroTargets = userProfile.macroTargets;

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nutrition Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Configure your daily targets',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              _buildMacroTargetTile(
                context,
                'Protein Target',
                '${macroTargets.proteins.round()}g',
                Icons.fitness_center,
                Colors.blue,
                () => _showMacroTargetDialog(
                  context,
                  'Protein',
                  macroTargets.proteins,
                  userProfile,
                ),
              ),
              _buildMacroTargetTile(
                context,
                'Carbs Target',
                '${macroTargets.carbs.round()}g',
                Icons.grain,
                Colors.green,
                () => _showMacroTargetDialog(
                  context,
                  'Carbs',
                  macroTargets.carbs,
                  userProfile,
                ),
              ),
              _buildMacroTargetTile(
                context,
                'Fat Target',
                '${macroTargets.fats.round()}g',
                Icons.opacity,
                Colors.orange,
                () => _showMacroTargetDialog(
                  context,
                  'Fat',
                  macroTargets.fats,
                  userProfile,
                ),
              ),
              const Divider(color: Colors.grey),
              ListTile(
                leading: const Icon(Icons.calculate, color: Colors.purple),
                title: const Text(
                  'Recalculate Targets',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Based on your TDEE: ${userProfile.tdee.round()} kcal',
                  style: TextStyle(color: Colors.grey[400]),
                ),
                onTap: () => _recalculateMacros(context, userProfile),
              ),
              const Divider(color: Colors.grey),
              ListTile(
                leading: const Icon(Icons.history, color: Colors.blue),
                title: const Text(
                  'Reports History',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'View your daily tracking reports',
                  style: TextStyle(color: Colors.grey[400]),
                ),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  Navigator.pushNamed(context, '/reports');
                },
              ),
              ListTile(
                leading: const Icon(Icons.restaurant_menu, color: Colors.orange),
                title: const Text(
                  'Daily Food Tracking',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Track your meals for today',
                  style: TextStyle(color: Colors.grey[400]),
                ),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  Navigator.pushNamed(context, '/daily-tracking');
                },
              ),
              const Divider(color: Colors.grey),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
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
          );
        },
      ),
    );
  }

  Widget _buildMacroTargetTile(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: Text(
        value,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }

  Future<void> _showMacroTargetDialog(
    BuildContext context,
    String macro,
    double currentValue,
    UserProfile userProfile,
  ) async {
    final controller = TextEditingController(text: currentValue.round().toString());

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Set $macro Target',
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Target (g)',
            labelStyle: const TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[700]!),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newValue = double.tryParse(controller.text);
              if (newValue != null) {
                final updatedMacros = MacroTargets(
                  proteins: macro == 'Protein'
                      ? newValue
                      : userProfile.macroTargets.proteins,
                  carbs: macro == 'Carbs' ? newValue : userProfile.macroTargets.carbs,
                  fats: macro == 'Fat' ? newValue : userProfile.macroTargets.fats,
                );

                final updatedProfile = userProfile.copyWith(
                  macroTargets: updatedMacros,
                );

                await context
                    .read<UserRepository>()
                    .updateUserProfile(updatedProfile);

                if (context.mounted) {
                  Navigator.pop(context);
                  // Refresh the screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
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