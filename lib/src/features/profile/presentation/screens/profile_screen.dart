import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class UserMetricsScreen extends StatelessWidget {
  const UserMetricsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (!state.isAuthenticated || state.userProfile == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final userProfile = state.userProfile!;
        final numberFormat = NumberFormat("#,##0.0", "pt_BR");

        return Scaffold(
          bottomNavigationBar: const BeShapeNavigatorBar(index: 3),
          backgroundColor: Colors.black,
          appBar: BeShapeAppBar(
            title: 'Perfil',
            hasLeading: false,
            
          ),
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(BeShapeImages.backgroundProfile))),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  _UserHeader(userProfile: userProfile),
                  const SizedBox(height: 24),
                  _MetricsOverview(
                      userProfile: userProfile, numberFormat: numberFormat),
                  const SizedBox(height: 24),
                  _CalorieBreakdown(
                      userProfile: userProfile, numberFormat: numberFormat),
                  const SizedBox(height: 24),
                  _WeightSection(
                      userProfile: userProfile, numberFormat: numberFormat),
                  const SizedBox(height: 24),
                  _MacrosCard(
                      userProfile: userProfile, numberFormat: numberFormat),
                  const SizedBox(height: 24),
                  _HealthSuggestions(userProfile: userProfile),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _UserHeader extends StatelessWidget {
  final UserProfile userProfile;

  const _UserHeader({required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            BeShapeColors.background.withOpacity(0.04),
            BeShapeColors.background.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        // border: Border.all(color: BeShapeColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                  image: userProfile.profileImageUrl != null
                      ? NetworkImage(userProfile.profileImageUrl!)
                      : NetworkImage(
                          'https://images.pexels.com/photos/2827392/pexels-photo-2827392.jpeg?auto=compress&cs=tinysrgb&w=1200'),
                  fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userProfile.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${userProfile.age} anos • ${userProfile.gender}',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Objetivo: ${userProfile.goal}',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricsOverview extends StatelessWidget {
  final UserProfile userProfile;
  final NumberFormat numberFormat;

  const _MetricsOverview({
    required this.userProfile,
    required this.numberFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BeShapeColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: BeShapeColors.border.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Visão Geral',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetric(
                'Altura',
                '${userProfile.height.round()} cm',
                Icons.height,
                Colors.purple,
              ),
              _buildMetric(
                'IMC',
                numberFormat.format(userProfile.bmi),
                Icons.monitor_weight,
                _getBMIColor(userProfile.bmi),
              ),
              _buildMetric(
                'Nível de Atividade',
                _getActivityLevel(userProfile.activityLevel),
                Icons.directions_run,
                Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return BeShapeColors.primary;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return BeShapeColors.primary;
    return Colors.red;
  }

  String _getActivityLevel(double level) {
    if (level <= 1.2) return 'Sedentário';
    if (level <= 1.375) return 'Leve';
    if (level <= 1.55) return 'Moderado';
    if (level <= 1.725) return 'Ativo';
    return 'Muito Ativo';
  }

  Widget _buildMetric(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _WeightSection extends StatelessWidget {
  final UserProfile userProfile;
  final NumberFormat numberFormat;

  const _WeightSection({
    required this.userProfile,
    required this.numberFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: BeShapeColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: BeShapeColors.border.withOpacity(0.3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progresso do Peso',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          WeightProgressChart(
            currentWeight: userProfile.weight,
            targetWeight: userProfile.targetWeight,
            initialWeight: userProfile.weight + 2,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeightInfo(
                'Peso Atual',
                '${numberFormat.format(userProfile.weight)} kg',
                Colors.blue,
              ),
              _buildWeightInfo(
                'Peso Ideal',
                '${numberFormat.format(userProfile.idealWeight)} kg',
                Colors.green,
              ),
              _buildWeightInfo(
                'Meta',
                '${numberFormat.format(userProfile.targetWeight)} kg',
                BeShapeColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeightInfo(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
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

class _MacrosCard extends StatelessWidget {
  final UserProfile userProfile;
  final NumberFormat numberFormat;

  const _MacrosCard({
    required this.userProfile,
    required this.numberFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: BeShapeColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: BeShapeColors.border.withOpacity(0.3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Distribuição de Macronutrientes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: MacroDistributionChart(
              proteins: userProfile.macroTargets.proteins,
              carbs: userProfile.macroTargets.carbs,
              fats: userProfile.macroTargets.fats,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMacroInfo(
                'Proteínas',
                '${numberFormat.format(userProfile.macroTargets.proteins)}g',
                Colors.blue,
              ),
              _buildMacroInfo(
                'Carboidratos',
                '${numberFormat.format(userProfile.macroTargets.carbs)}g',
                Colors.green,
              ),
              _buildMacroInfo(
                'Gorduras',
                '${numberFormat.format(userProfile.macroTargets.fats)}g',
                Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroInfo(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _CalorieBreakdown extends StatelessWidget {
  final UserProfile userProfile;
  final NumberFormat numberFormat;

  const _CalorieBreakdown({
    required this.userProfile,
    required this.numberFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: BeShapeColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gasto Calórico',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildCalorieItem(
            'Taxa Metabólica Basal (TMB)',
            numberFormat.format(userProfile.bmr),
            'Calorias gastas em repouso',
            Colors.purple,
          ),
          const SizedBox(height: 12),
          _buildCalorieItem(
            'Gasto Energético Total (TDEE)',
            numberFormat.format(userProfile.tdee),
            'Calorias gastas por dia',
            BeShapeColors.primary,
          ),
          const SizedBox(height: 12),
          _buildCalorieItem(
            'Meta Calórica Diária',
            numberFormat.format(_getCalorieTarget(userProfile)),
            _getCalorieTargetDescription(userProfile.goal),
            Colors.green,
          ),
        ],
      ),
    );
  }

  double _getCalorieTarget(UserProfile profile) {
    switch (profile.goal.toLowerCase()) {
      case 'lose_weight':
        return profile.tdee - 500;
      case 'bulk':
        return profile.tdee + 300;
      default:
        return profile.tdee;
    }
  }

  String _getCalorieTargetDescription(String goal) {
    switch (goal.toLowerCase()) {
      case 'lose_weight':
        return 'Déficit de 500 kcal para perda de peso';
      case 'bulk':
        return 'Superávit de 300 kcal para ganho de massa';
      default:
        return 'Manutenção do peso atual';
    }
  }

  Widget _buildCalorieItem(
      String title, String value, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.3),
            color.withOpacity(0.3),
            BeShapeColors.background.withOpacity(0.2),
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.local_fire_department, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$value kcal',
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthSuggestions extends StatelessWidget {
  final UserProfile userProfile;

  const _HealthSuggestions({required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: BeShapeColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sugestões de Melhoria',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ..._buildSuggestions(),
        ],
      ),
    );
  }

  List<Widget> _buildSuggestions() {
    final suggestions = <Widget>[];

    // Verifica IMC
    if (userProfile.bmi < 18.5) {
      suggestions.add(_buildSuggestion(
        'Aumente a ingestão calórica',
        'Seu IMC está abaixo do ideal. Considere aumentar o consumo de proteínas e gorduras boas.',
        Icons.trending_up,
        BeShapeColors.primary,
      ));
    } else if (userProfile.bmi > 25) {
      suggestions.add(_buildSuggestion(
        'Monitore a ingestão calórica',
        'Seu IMC está acima do ideal. Foque em alimentos nutritivos e menos calóricos.',
        Icons.monitor_weight,
        Colors.red,
      ));
    }

    // Verifica nível de atividade
    if (userProfile.activityLevel <= 1.2) {
      suggestions.add(_buildSuggestion(
        'Aumente seu nível de atividade',
        'Tente incluir mais exercícios na sua rotina para melhorar sua saúde geral.',
        Icons.directions_run,
        Colors.green,
      ));
    }

    // Verifica proteína
    final proteinPerKg = userProfile.macroTargets.proteins / userProfile.weight;
    if (proteinPerKg < 1.6) {
      suggestions.add(_buildSuggestion(
        'Aumente o consumo de proteínas',
        'Para seus objetivos, considere aumentar a ingestão de proteínas.',
        Icons.egg_alt,
        Colors.blue,
      ));
    }

    // Se não houver sugestões
    if (suggestions.isEmpty) {
      suggestions.add(_buildSuggestion(
        'Continue assim!',
        'Seus indicadores estão ótimos. Mantenha o bom trabalho!',
        Icons.check_circle,
        Colors.green,
      ));
    }

    return suggestions;
  }

  Widget _buildSuggestion(
      String title, String description, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.3),
              color.withOpacity(0.3),
              color.withOpacity(0.3),
              BeShapeColors.background.withOpacity(0.2),
            ],
          ),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
