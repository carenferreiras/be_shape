import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../../../core/core.dart';

class CustomFloatingButton extends StatelessWidget {
  final void Function()? onTap;
  const CustomFloatingButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,
          backgroundColor: BeShapeColors.primary,
          foregroundColor: BeShapeColors.background,
          activeBackgroundColor: Colors.red,
          activeForegroundColor: Colors.white,
          buttonSize: const Size(56.0, 56.0),
          visible: true,
          closeManually: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          elevation: 8.0,
          shape: const CircleBorder(),
          children: [
            SpeedDialChild(
              child: const Icon(Icons.bookmark_add),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              label: 'Add Saved Food',
              labelStyle:
                  const TextStyle(fontSize: 16.0, color: BeShapeColors.primary),
              labelBackgroundColor: BeShapeColors.background.withOpacity(0.7),
              onTap: () => Navigator.pushNamed(context, '/saved-food'),
            ),
            SpeedDialChild(
              child: const Icon(Icons.add),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              label: 'Add New Food',
              labelStyle:
                  const TextStyle(fontSize: 16.0, color: BeShapeColors.primary),
              labelBackgroundColor: BeShapeColors.background.withOpacity(0.7),
              onTap: () => Navigator.pushNamed(context, '/add-food'),
            ),
            SpeedDialChild(
              child: const Icon(Icons.check),
              backgroundColor: BeShapeColors.primary,
              foregroundColor: Colors.white,
              label: 'Complete Day',
              labelBackgroundColor: BeShapeColors.background.withOpacity(0.7),
              labelStyle:
                  const TextStyle(fontSize: 16.0, color: BeShapeColors.primary),
              onTap: onTap,
            ),
          ],
        )
;
  }
}