import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../../auth/auth.dart';

class ProfileHeader extends StatelessWidget {
  final void Function()? onTap;
  final String? image;
  final UserProfile? userProfile;

  const ProfileHeader({super.key, this.onTap, this.image, this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: BeShapeColors.backgroundLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: BeShapeColors.primary,width: 2),
                  image: DecorationImage(image: 
                  image != null
                    ? NetworkImage(image!)
                    : const AssetImage(BeShapeImages.female) as ImageProvider,fit: BoxFit.cover
                  ),
                  
                ),
              ),
               Container(
               decoration: BoxDecoration(
                color: BeShapeColors.primary,
                borderRadius: BorderRadius.circular(8)
               ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: BeShapeSizes.paddingMedium),
          child: Text(
            userProfile!.name,
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "${userProfile!.age} anos | ${userProfile!.gender}",
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ],
    );
  }
}