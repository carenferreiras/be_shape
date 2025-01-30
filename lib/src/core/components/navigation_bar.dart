import 'package:flutter/material.dart';

import '../core.dart';

class BeShapeNavigatorBar extends StatelessWidget {
  final int index;
  const BeShapeNavigatorBar({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        backgroundColor: Colors.grey[900],
        indicatorColor: BeShapeColors.primary.withOpacity(0.2),
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                color: BeShapeColors.primary,
                fontWeight: FontWeight.bold,
              );
            }
            return const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.normal,
            );
          },
        ),
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: BeShapeColors.primary);
            }
            return const IconThemeData(color: Colors.grey);
          },
        ),
      ),
      child: NavigationBar(
        selectedIndex: index,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.fitness_center),
            icon: Icon(Icons.fitness_center),
            label: 'Workouts',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.restaurant_menu),
            icon: Icon(Icons.restaurant_menu),
            label: 'Nutrition',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/exercises-list');
              break;
            case 2:
              Navigator.pushNamed(context, '/daily-tracking');
              break;
            case 3:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}