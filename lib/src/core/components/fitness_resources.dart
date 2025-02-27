import 'package:flutter/material.dart';

import '../core.dart';

class FitnessResources extends StatelessWidget {
  const FitnessResources({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Fitness Resources',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'See All',
              style: TextStyle(
                color: BeShapeColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const _ResourceCard(
          title: 'Stretching and Recovery Sessions',
          subtitle: 'Techniques Served',
          image: 'assets/images/stretching.jpg',
          stats: ['43', '12%', '22'],
        ),
        const SizedBox(height: 12),
        const _ResourceCard(
          title: 'Advanced Core Strengthening Pilates',
          subtitle: 'Alan D. Toring',
          image: 'assets/images/pilates.jpg',
          stats: ['25', '86%', '19'],
        ),
        const SizedBox(height: 12),
        const _ResourceCard(
          title: 'Full Body Resistance',
          subtitle: 'Alan D. Toring',
          image: 'assets/images/resistance.jpg',
          stats: ['35', '92%', '28'],
        ),
      ],
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final List<String> stats;

  const _ResourceCard({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _StatBadge(
                      value: stats[0],
                      icon: Icons.star,
                      color: Colors.yellow,
                    ),
                    const SizedBox(width: 8),
                    _StatBadge(
                      value: stats[1],
                      icon: Icons.favorite,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 8),
                    _StatBadge(
                      value: stats[2],
                      icon: Icons.people,
                      color: BeShapeColors.link,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: BeShapeColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.play_arrow,
              color: BeShapeColors.primary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String value;
  final IconData icon;
  final Color color;

  const _StatBadge({
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}