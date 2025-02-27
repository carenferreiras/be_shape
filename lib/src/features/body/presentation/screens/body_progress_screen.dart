import 'package:be_shape_app/src/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../features.dart';

class BodyProgressScreen extends StatefulWidget {
  const BodyProgressScreen({super.key});

  @override
  State<BodyProgressScreen> createState() => _BodyProgressScreenState();
}

class _BodyProgressScreenState extends State<BodyProgressScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _weightController = TextEditingController();
  final Map<String, TextEditingController> _measurementControllers = {
    'Chest': TextEditingController(),
    'Waist': TextEditingController(),
    'Hips': TextEditingController(),
    'Arms': TextEditingController(),
    'Thighs': TextEditingController(),
    'Calves': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadInitialData();
  }

  void _loadInitialData() {
    final userProfile = context.read<AuthBloc>().state.userProfile;
    if (userProfile != null) {
      _weightController.text = userProfile.weight.toString();
      // Load latest measurements if available
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _weightController.dispose();
    for (var controller in _measurementControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _saveMeasurements(BuildContext context) async {
    try {
      final userId = context.read<AuthBloc>().currentUserId;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated')),
        );
        return;
      }

      final weight = double.tryParse(_weightController.text);
      if (weight == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, insira um peso válido')),
        );
        return;
      }

      final userProfile = context.read<AuthBloc>().state.userProfile!;
      final height = userProfile.height / 100;
      final bmi = weight / (height * height);
      final bodyFat =
          _calculateBodyFat(bmi, userProfile.age, userProfile.gender);

      final measurement = BodyMeasurement(
        id: DateTime.now().toString(),
        userId: userId,
        date: DateTime.now(),
        weight: weight,
        measurements: {},
        bmi: bmi,
        bodyFat: bodyFat,
      );

      context.read<BodyMeasurementBloc>().add(AddMeasurement(measurement));

      final updatedHistory = [
        ...userProfile.weightHistory,
        {'date': DateTime.now().toIso8601String(), 'weight': weight, 'bmi': bmi}
      ];

      final updatedProfile = userProfile.copyWith(
          weight: weight, bmi: bmi, weightHistory: updatedHistory);
      await context.read<UserRepository>().updateUserProfile(updatedProfile);

      context.read<AuthBloc>().add(UpdateUserProfile(updatedProfile));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Medidas salvas com sucesso!'),
            backgroundColor: Colors.green),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erro ao salvar medidas: ${e.toString()}'),
            backgroundColor: Colors.red),
      );
    }
  }

  double _calculateBodyFat(double bmi, int age, String gender) {
    // Simplified body fat calculation using BMI
    // This is a rough estimate - for more accurate results, use skinfold measurements
    final genderFactor = gender.toLowerCase() == 'male' ? 1.0 : 0.8;
    final ageFactor = age * 0.23;
    return (1.2 * bmi + 0.23 * ageFactor - 5.4 * genderFactor).clamp(5.0, 50.0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (!state.isAuthenticated || state.userProfile == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final userProfile = state.userProfile!;

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            leading: Card(
              margin: const EdgeInsets.all(6),
              color: BeShapeColors.primary.withOpacity(0.3),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: BeShapeColors.primary,
                ),
              ),
            ),
            title: const Text(
              'Progresso Corporal',
              style: TextStyle(color: BeShapeColors.textPrimary),
            ),
            backgroundColor: Colors.black,
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Visão Geral'),
                Tab(text: 'Histórico'),
                Tab(text: 'Relatórios'),
              ],
              
              indicatorColor: BeShapeColors.primary,
              labelColor: BeShapeColors.primary,
              unselectedLabelColor: Colors.grey,
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _OverviewTab(userProfile: userProfile),
              _HistoryTab(userProfile: userProfile),
              _ReportsTab(userProfile: userProfile),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddMeasurementDialog(context),
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _showAddMeasurementDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nova Medição',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Weight input
              _buildMeasurementField(
                'Peso (kg)',
                _weightController,
                Icons.monitor_weight,
              ),
              const SizedBox(height: 16),

              // Body measurements
              const Text(
                'Medidas Corporais (cm)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              ...['Chest', 'Waist', 'Hips', 'Arms', 'Thighs', 'Calves']
                  .map((part) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildMeasurementField(
                    part,
                    _measurementControllers[part]!,
                    Icons.straighten,
                  ),
                );
              }).toList(),

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _saveMeasurements(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Salvar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMeasurementField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[800]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue),
        ),
        filled: true,
        fillColor: Colors.grey[850],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final UserProfile userProfile;

  const _OverviewTab({required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWeightCard(),
          const SizedBox(height: 24),
          _buildBMICard(),
          const SizedBox(height: 24),
          _buildMeasurementsCard(),
        ],
      ),
    );
  }

  Widget _buildWeightCard() {
    final NumberFormat _formatter = NumberFormat("#,##0.00", "en_US");

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.monitor_weight,
                  color: Colors.blue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Progresso do Peso',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: WeightProgressChart(
              currentWeight: userProfile.weight,
              targetWeight: userProfile.targetWeight,
              initialWeight: userProfile.weight + 2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeightInfo(
                'Peso Atual',
                '${_formatter.format(userProfile.weight)}kg',
                Colors.blue,
              ),
              _buildWeightInfo(
                'Peso Ideal',
                '${_formatter.format(userProfile.targetWeight)}kg',
                Colors.green,
              ),
              _buildWeightInfo(
                'Diferença',
                '${_formatter.format((userProfile.weight - userProfile.targetWeight).abs())}kg',
                Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBMICard() {
    final bmiColor = _getBMIColor(userProfile.bmi);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bmiColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bmiColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.health_and_safety,
                  color: bmiColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Índice de Massa Corporal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: bmiColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  userProfile.bmiClassification,
                  style: TextStyle(
                    color: bmiColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userProfile.bmi.toStringAsFixed(1),
                style: TextStyle(
                  color: bmiColor,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'kg/m²',
                style: TextStyle(
                  color: bmiColor.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: bmiColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getBMIRecommendation(userProfile.bmi),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
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

  Widget _buildMeasurementsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.straighten,
                  color: Colors.purple,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Medidas Corporais',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Add measurements grid or list here
          // This will be populated with actual measurement data
          const Center(
            child: Text(
              'Nenhuma medida registrada',
              style: TextStyle(color: Colors.grey),
            ),
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
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.orange;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }

  String _getBMIRecommendation(double bmi) {
    if (bmi < 18.5) {
      return 'Considere aumentar sua ingestão calórica e incluir exercícios de força para ganhar peso de forma saudável.';
    } else if (bmi < 25) {
      return 'Seu peso está dentro da faixa considerada saudável. Continue mantendo bons hábitos!';
    } else if (bmi < 30) {
      return 'Considere ajustar sua dieta e aumentar a atividade física para alcançar um peso mais saudável.';
    } else {
      return 'Recomendamos consultar um profissional de saúde para desenvolver um plano personalizado de perda de peso.';
    }
  }
}

class _HistoryTab extends StatelessWidget {
  final UserProfile userProfile;
  final NumberFormat _formatter = NumberFormat("#,##0.00", "en_US");

  _HistoryTab({required this.userProfile});

  @override
  Widget build(BuildContext context) {
    final history =
        userProfile.weightHistory.reversed.toList(); // Mais recente primeiro

    if (history.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum histórico disponível.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final entry = history[index];
        final date = DateTime.parse(entry['date']);
        final formattedDate = DateFormat('dd/MM/yyyy').format(date);
        final weight = _formatter.format(entry['weight']);
        final bmi = _formatter.format(entry['bmi']);

        return Card(
          color: Colors.grey[900],
          child: ListTile(
            title: Text('Peso: $weight kg | IMC: $bmi',
                style: const TextStyle(color: Colors.white)),
            subtitle: Text('Data: $formattedDate',
                style: const TextStyle(color: Colors.grey)),
          ),
        );
      },
    );
  }
}

class _ReportsTab extends StatelessWidget {
  final UserProfile userProfile;

  const _ReportsTab({required this.userProfile});

  @override
  Widget build(BuildContext context) {
    // Implement reports view
    return const Center(
      child: Text(
        'Relatórios de Progresso',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
