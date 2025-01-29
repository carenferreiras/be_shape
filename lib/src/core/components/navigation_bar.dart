import 'package:flutter/material.dart';

import '../core.dart';

class BeShapeNavigatorBar extends StatelessWidget {
  final int index;
  const BeShapeNavigatorBar({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: Colors.grey[900],
      indicatorColor: BeShapeColors.primary.withOpacity(0.2),
      selectedIndex: index,
      destinations: const [
        NavigationDestination(
          selectedIcon: Icon(
            Icons.home,
            color: BeShapeColors.primary,
          ),
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          selectedIcon: Icon(
            Icons.fitness_center,
            color: BeShapeColors.primary,
          ),
          icon: Icon(Icons.fitness_center),
          label: 'Workouts',
        ),
        NavigationDestination(
          selectedIcon: Icon(
            Icons.restaurant_menu,
            color: BeShapeColors.primary,
          ),
          icon: Icon(Icons.restaurant_menu),
          label: 'Nutrition',
        ),
        NavigationDestination(
          selectedIcon: Icon(
            Icons.person,
            color: BeShapeColors.primary,
          ),
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      onDestinationSelected: (index) {
        switch (index) {
          case 0: // Nutrition tab
            Navigator.pushNamed(context, '/home');
            break;
          case 2: // Nutrition tab
            Navigator.pushNamed(context, '/daily-tracking');
            break;
          case 1: // Nutrition tab
            Navigator.pushNamed(context, '/exercises-list');
            break;
          case 3: // Nutrition tab
            Navigator.pushNamed(context, '/habit');
            break;
        }
      },
    );
  }
}
