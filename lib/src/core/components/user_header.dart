import 'package:be_shape_app/src/core/core.dart';
import 'package:flutter/material.dart';

import '../../features/features.dart';

class UserHeader extends StatelessWidget {
  final UserProfile userProfile;

  const UserHeader({
    super.key,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  'Olá, ${userProfile.name}!',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: BeShapeColors.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            size: 16,
                            color: BeShapeColors.primary,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '88% Healthy',
                            style: TextStyle(
                              color: BeShapeColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.workspace_premium,
                            size: 16,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Pro',
                            style: TextStyle(
                              color: Colors.blue[300],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Card(
              color: BeShapeColors.primary.withOpacity(0.2),
              child: IconButton(
                onPressed: () => Navigator.pushNamed(context, '/profile'),
                icon: Icon(
                  Icons.person,
                  color: BeShapeColors.primary,
                ),
              )),
        ],
      ),
    );
  }
}
