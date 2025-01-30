import 'package:flutter/material.dart';

class BuildCard extends StatelessWidget {
  final IconData icon;
  final String boldTitle;
  final String title;
  final Color color;
  const BuildCard(
      {super.key,
      required this.icon,
      required this.boldTitle,
      required this.title, 
      required this.color, 
     });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: color.withOpacity(0.2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 30,
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      boldTitle,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'g',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
