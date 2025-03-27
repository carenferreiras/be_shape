import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../../../core/core.dart';

class CustomFloatingButton extends StatelessWidget {
  final void Function()? onTap;
  const CustomFloatingButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.more_horiz_outlined,
      activeIcon: Icons.close,
      backgroundColor: BeShapeColors.primary.withValues(alpha: (0.2)),
      foregroundColor: BeShapeColors.primary,
      activeBackgroundColor: Colors.red,
      activeForegroundColor: Colors.white,
      buttonSize: const Size(56.0, 56.0),
      visible: true,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: BeShapeColors.background,
      overlayOpacity: 0.5,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: BeShapeColors.primary,
        ),
        borderRadius: BorderRadius.circular(BeShapeSizes.paddingMedium),
      ),
      children: [
        SpeedDialChild(
          child: const Icon(Icons.bookmark_add),
          backgroundColor: BeShapeColors.link,
          foregroundColor: Colors.white,
          label: 'Add Saved Food',
          labelStyle:
              const TextStyle(fontSize: 16.0, color: BeShapeColors.primary),
          labelBackgroundColor:
              BeShapeColors.background.withValues(alpha: (0.7)),
          onTap: () => Navigator.pushNamed(context, '/saved-food'),
        ),
        SpeedDialChild(
          child: const Icon(Icons.add),
          backgroundColor: BeShapeColors.accent,
          foregroundColor: Colors.white,
          label: 'Add New Food',
          labelStyle:
              const TextStyle(fontSize: 16.0, color: BeShapeColors.primary),
          labelBackgroundColor:
              BeShapeColors.background.withValues(alpha: (0.7)),
          onTap: () => Navigator.pushNamed(context, '/add-food'),
        ),
        SpeedDialChild(
          child: const Icon(Icons.check),
          backgroundColor: BeShapeColors.primary,
          foregroundColor: Colors.white,
          label: 'Complete Day',
          labelBackgroundColor:
              BeShapeColors.background.withValues(alpha: (0.7)),
          labelStyle:
              const TextStyle(fontSize: 16.0, color: BeShapeColors.primary),
          onTap: onTap,
        ),
      ],
    );
  }
}
