import 'package:be_shape_app/src/features/features.dart';
import 'package:flutter/material.dart';

import '../../../../core/core.dart';

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
              // CircleAvatar(
              //   radius: 50,
              //   backgroundImage: image != null
              //       ? NetworkImage(image!)
              //       : const AssetImage(BeShapeImages.beShape) as ImageProvider,
              // ),
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
        Text(
          userProfile!.name,
          style: const TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
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