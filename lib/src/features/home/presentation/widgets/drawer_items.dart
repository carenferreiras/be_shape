import 'package:flutter/material.dart';

class DrawerItems extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color iconColor;
  final VoidCallback onTap;
  const DrawerItems(
      {super.key,
      required this.icon,
      required this.title,
      this.subtitle,
      required this.iconColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle ?? '',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 13,
                  ),
                )
              : null,
          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.grey,
            size: 20,
          ),
        ),
      ),
    );
  }
}
