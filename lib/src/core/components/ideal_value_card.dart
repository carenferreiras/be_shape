import 'package:flutter/material.dart';
import '../../features/auth/auth.dart';
import '../core.dart';

class IdealValuesCard extends StatelessWidget {
  final UserProfile userProfile;

  const IdealValuesCard({
    super.key,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: BeShapeColors.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: BeShapeColors.primary.withOpacity(0.3),
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
                  BeShapeColors.primary.withOpacity(0.2),
                  BeShapeColors.primary.withOpacity(0.05),
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
                    color: BeShapeColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.restaurant_menu,
                    color: BeShapeColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sugestões de Alimentos',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Para atingir suas metas diárias',
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
          // Macros Sections
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildMacroSection(
                  'Proteínas',
                  userProfile.macroTargets.proteins,
                  [
                    _FoodSuggestion(
                      name: 'Frango Grelhado',
                      amount: '100g',
                      macroAmount: '31g proteína',
                      icon: '🍗',
                    ),
                    _FoodSuggestion(
                      name: 'Ovo',
                      amount: '1 unidade',
                      macroAmount: '6g proteína',
                      icon: '🥚',
                    ),
                    _FoodSuggestion(
                      name: 'Atum',
                      amount: '100g',
                      macroAmount: '26g proteína',
                      icon: '🐟',
                    ),
                  ],
                  Colors.blue,
                ),
                const SizedBox(height: 20),
                _buildMacroSection(
                  'Carboidratos',
                  userProfile.macroTargets.carbs,
                  [
                    _FoodSuggestion(
                      name: 'Arroz Integral',
                      amount: '100g',
                      macroAmount: '25g carboidratos',
                      icon: '🍚',
                    ),
                    _FoodSuggestion(
                      name: 'Batata Doce',
                      amount: '100g',
                      macroAmount: '20g carboidratos',
                      icon: '🍠',
                    ),
                    _FoodSuggestion(
                      name: 'Aveia',
                      amount: '100g',
                      macroAmount: '66g carboidratos',
                      icon: '🥣',
                    ),
                  ],
                  Colors.green,
                ),
                const SizedBox(height: 20),
                _buildMacroSection(
                  'Gorduras Boas',
                  userProfile.macroTargets.fats,
                  [
                    _FoodSuggestion(
                      name: 'Abacate',
                      amount: '100g',
                      macroAmount: '15g gorduras',
                      icon: '🥑',
                    ),
                    _FoodSuggestion(
                      name: 'Castanhas',
                      amount: '30g',
                      macroAmount: '15g gorduras',
                      icon: '🥜',
                    ),
                    _FoodSuggestion(
                      name: 'Azeite',
                      amount: '1 colher',
                      macroAmount: '14g gorduras',
                      icon: '🫒',
                    ),
                  ],
                  Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroSection(
    String title,
    double target,
    List<_FoodSuggestion> suggestions,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.restaurant,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              '${target.round()}g',
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  BeShapeColors.primary.withOpacity(0.2),
                  BeShapeColors.primary.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: BeShapeColors.primary.withOpacity(0.3))),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            itemCount: suggestions.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey[800],
              height: 16,
            ),
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];
              return Row(
                children: [
                  Text(
                    suggestion.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          suggestion.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          suggestion.amount,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      suggestion.macroAmount,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FoodSuggestion {
  final String name;
  final String amount;
  final String macroAmount;
  final String icon;

  const _FoodSuggestion({
    required this.name,
    required this.amount,
    required this.macroAmount,
    required this.icon,
  });
}
