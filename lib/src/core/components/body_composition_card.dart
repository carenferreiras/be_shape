import 'package:flutter/material.dart';

import '../../features/features.dart';
import '../core.dart';

class BodyCompositionCard extends StatelessWidget {
  final UserProfile userProfile;

  const BodyCompositionCard({
    super.key,
    required this.userProfile,
  });

  String _getAvatarType() {
    final bmi = userProfile.weight /
        ((userProfile.height / 100) * (userProfile.height / 100));

    if (bmi < 18.5) {
      return 'Abaixo';
    } else if (bmi >= 18.5 && bmi < 25) {
      return 'Normal';
    } else if (bmi >= 25 && bmi < 27) {
      return 'Acima 1';
    } else if (bmi >= 27 && bmi < 30) {
      return 'Acima 2';
    } else if (bmi >= 30 && bmi < 35) {
      return 'Acima 3';
    } else if (bmi >= 35 && bmi < 40) {
      return 'Alto 1';
    } else if (bmi >= 40 && bmi < 45) {
      return 'Alto 2';
    } else {
      return 'Alto 3';
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarType = _getAvatarType();
    final bmi = userProfile.weight /
        ((userProfile.height / 100) * (userProfile.height / 100));

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[900]!,
            Colors.grey[850]!,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.grey[800]!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.purple.withValues(alpha: (0.2)),
                  Colors.purple.withValues(alpha: (0.05)),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: (0.2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    color: Colors.purple,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Body Composition',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Based on your metrics',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Avatar Section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAvatarItem('Abaixo', avatarType == 'Abaixo'),
                    _buildAvatarItem('Normal', avatarType == 'Normal'),
                    _buildAvatarItem('Acima 1', avatarType == 'Acima 1'),
                    _buildAvatarItem('Acima 2', avatarType == 'Acima 2'),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAvatarItem('Acima 3', avatarType == 'Acima 3'),
                    _buildAvatarItem('Alto 1', avatarType == 'Alto 1'),
                    _buildAvatarItem('Alto 2', avatarType == 'Alto 2'),
                    _buildAvatarItem('Alto 3', avatarType == 'Alto 3'),
                  ],
                ),
                const SizedBox(height: 24),
                // Metrics
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _buildMetricRow(
                        'Weight',
                        '${userProfile.weight.toStringAsFixed(1)} kg',
                        Icons.monitor_weight,
                        BeShapeColors.primary,
                      ),
                      const SizedBox(height: 16),
                      _buildMetricRow(
                        'Height',
                        '${userProfile.height.toStringAsFixed(1)} cm',
                        Icons.height,
                        BeShapeColors.accent,
                      ),
                      const SizedBox(height: 16),
                      _buildMetricRow(
                        'bmi',
                        bmi.toStringAsFixed(1),
                        Icons.analytics,
                        BeShapeColors.link,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarItem(String type, bool isSelected) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 100,
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.purple.withValues(alpha: (0.2))
                : Colors.grey[850],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.purple : Colors.transparent,
              width: 2,
            ),
          ),
          child: Image.asset(
            'assets/images/avatars/${userProfile.gender.toLowerCase()}/$type.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          type,
          style: TextStyle(
            color: isSelected ? Colors.purple : Colors.grey,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricRow(
      String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: (0.15)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
