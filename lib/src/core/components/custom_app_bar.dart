import 'package:flutter/material.dart';

import '../core.dart';

class BeShapeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final IconData? actionIcon;
  final bool hasLeading;
  final void Function()? actionIconPressed;
  final Color? appBarColor;
  const BeShapeAppBar(
      {super.key,
      this.title,
      this.actionIcon,
      this.actionIconPressed,
      this.hasLeading = true,
      this.appBarColor});

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      title: Text(
        title ?? '',
        style: const TextStyle(color: Colors.white),
      ),
      actions: [
        Card(
          margin: const EdgeInsets.all(6),
          color: BeShapeColors.primary.withOpacity(0.3),
          child: IconButton(
            onPressed: actionIconPressed,
            icon: Icon(
              actionIcon ?? Icons.person,
              color: BeShapeColors.primary,
            ),
          ),
        ),
      ],
      leading: 
      hasLeading?
      Card(
        margin: const EdgeInsets.all(6),
        color: BeShapeColors.primary.withOpacity(0.3),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: BeShapeColors.primary,
          ),
        ),
      ): const SizedBox.shrink(),
      backgroundColor: appBarColor?? Colors.black,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(55);
}
