import 'package:be_shape_app/src/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features.dart';

class EquipmentScreen extends StatefulWidget {
  const EquipmentScreen({super.key});

  @override
  State<EquipmentScreen> createState() => _EquipmentScreenState();
}

class _EquipmentScreenState extends State<EquipmentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadEquipment();
  }

  void _loadEquipment() {
    final userId = context.read<AuthBloc>().currentUserId;
    if (userId != null) {
      context.read<EquipmentBloc>().add(LoadUserEquipment(userId));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Equipamentos',
          style: TextStyle(color: BeShapeColors.textPrimary),
        ),
        leading: Card(
          margin: const EdgeInsets.all(6),
          color: BeShapeColors.primary.withValues(alpha: (0.3)),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: BeShapeColors.primary,
            ),
          ),
        ),
        backgroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Meus Equipamentos'),
            Tab(text: 'Sugestões'),
          ],
          indicatorColor: BeShapeColors.primary,
          labelColor: BeShapeColors.primary,
          unselectedLabelColor: Colors.grey,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _UserEquipmentTab(),
          _SuggestedEquipmentTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-equipment');
        },
        backgroundColor: BeShapeColors.primary,
        child: const Icon(
          Icons.add,
          color: BeShapeColors.textPrimary,
        ),
      ),
    );
  }
}

class _UserEquipmentTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EquipmentBloc, EquipmentState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.equipment.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: (0.2)),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.fitness_center,
                    color: Colors.blue,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Nenhum equipamento cadastrado',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Adicione seus equipamentos para começar',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/add-equipment');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar Equipamento'),
                ),
              ],
            ),
          );
        }

        // Group equipment by category
        final groupedEquipment = <EquipmentCategory, List<Equipment>>{};
        for (final equipment in state.equipment) {
          groupedEquipment
              .putIfAbsent(equipment.category, () => [])
              .add(equipment);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: groupedEquipment.length,
          itemBuilder: (context, index) {
            final category = groupedEquipment.keys.elementAt(index);
            final equipments = groupedEquipment[category]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(category)
                            .withValues(alpha: (0.2)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getCategoryIcon(category),
                        color: _getCategoryColor(category),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _getCategoryName(category),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...equipments.map((equipment) => _EquipmentCard(
                      color: _getCategoryColor(category),
                      equipment: equipment,
                    )),
                const SizedBox(height: 24),
              ],
            );
          },
        );
      },
    );
  }

  Color _getCategoryColor(EquipmentCategory category) {
    switch (category) {
      case EquipmentCategory.freeWeight:
        return Colors.blue;
      case EquipmentCategory.resistance:
        return Colors.green;
      case EquipmentCategory.cardio:
        return Colors.orange;
      case EquipmentCategory.calisthenics:
        return Colors.purple;
      case EquipmentCategory.machine:
        return Colors.red;
      case EquipmentCategory.recovery:
        return Colors.cyan;
      case EquipmentCategory.explosive:
        return Colors.yellow;
      case EquipmentCategory.cable:
        return Colors.brown;
      case EquipmentCategory.bodyweight:
        return Colors.cyan;
      case EquipmentCategory.functional:
        return Colors.red;
      case EquipmentCategory.accessory:
        return Colors.black54;
    }
  }

  IconData _getCategoryIcon(EquipmentCategory category) {
    switch (category) {
      case EquipmentCategory.freeWeight:
        return Icons.fitness_center;
      case EquipmentCategory.resistance:
        return Icons.linear_scale;
      case EquipmentCategory.cardio:
        return Icons.directions_run;
      case EquipmentCategory.calisthenics:
        return Icons.accessibility_new;
      case EquipmentCategory.machine:
        return Icons.settings;
      case EquipmentCategory.recovery:
        return Icons.healing;
      case EquipmentCategory.explosive:
        return Icons.flash_on;
      case EquipmentCategory.cable:
        return Icons.cable;
      case EquipmentCategory.bodyweight:
        return Icons.boy_rounded;
      case EquipmentCategory.functional:
        return Icons.sports_gymnastics_sharp;
      case EquipmentCategory.accessory:
        return Icons.access_alarms_outlined;
    }
  }

  String _getCategoryName(EquipmentCategory category) {
    switch (category) {
      case EquipmentCategory.freeWeight:
        return 'Pesos Livres';
      case EquipmentCategory.resistance:
        return 'Resistência';
      case EquipmentCategory.cardio:
        return 'Cardio';
      case EquipmentCategory.calisthenics:
        return 'Calistenia';
      case EquipmentCategory.machine:
        return 'Máquinas';
      case EquipmentCategory.recovery:
        return 'Recuperação';
      case EquipmentCategory.explosive:
        return 'Explosão';
      case EquipmentCategory.cable:
        return 'Cabos';
      case EquipmentCategory.bodyweight:
        return 'Peso';
      case EquipmentCategory.functional:
        return 'Funcional';
      case EquipmentCategory.accessory:
        return 'Acessório';
    }
  }
}

class _SuggestedEquipmentTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCategorySection(
          'Equipamentos de Academia',
          'Máquinas e equipamentos profissionais',
          const [
            'Leg Press',
            'Smith Machine',
            'Hack Squat',
            'Cadeira Extensora',
            'Cadeira Flexora',
            'Pec Deck',
            'Graviton',
            'Banco Scott',
            'Máquina Panturrilha',
            'Esteira',
            'Bicicleta Ergométrica',
            'Elíptico',
          ],
          Colors.green,
        ),
        _buildCategorySection(
          'Essenciais',
          'Equipamentos básicos para começar',
          const [
            'Faixas elásticas',
            'Halteres',
            'Tapete de exercício',
            'Barra fixa',
            'Corda de pular',
          ],
          Colors.green,
        ),
        const SizedBox(height: 24),
        _buildCategorySection(
          'Intermediários',
          'Para expandir suas possibilidades',
          const [
            'Kettlebell',
            'Rolo de espuma',
            'TRX',
            'Bola suíça',
            'Banco ajustável',
          ],
          Colors.blue,
        ),
        const SizedBox(height: 24),
        _buildCategorySection(
          'Avançados',
          'Para treinos mais intensos',
          const [
            'Rack de agachamento',
            'Barra olímpica',
            'Anilhas',
            'Plataforma de peso',
            'Puxador',
          ],
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildCategorySection(
    String title,
    String subtitle,
    List<String> items,
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
                color: color.withValues(alpha: (0.2)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.category,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            // Create a default suggestion if not found in the map
            final suggestion = suggestedEquipments[items[index]] ??
                SuggestedEquipment(
                  name: items[index],
                  category: EquipmentCategory.freeWeight,
                  description: 'Equipamento para treino avançado',
                  muscleGroups: ['Múltiplos grupos musculares'],
                  exercises: ['Exercícios variados'],
                );

            return _SuggestedEquipmentCard(
              suggestion: suggestion,
              color: color,
            );
          },
        ),
      ],
    );
  }
}

class _SuggestedEquipmentCard extends StatelessWidget {
  final SuggestedEquipment suggestion;
  final Color color;

  const _SuggestedEquipmentCard({
    required this.suggestion,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddEquipmentScreen(suggestion: suggestion),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color..withValues(alpha: (0.3))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: (0.2)),
                    Colors.transparent,
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: (0.2)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.fitness_center,
                      color: color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      suggestion.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    suggestion.description,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.accessibility_new,
                        color: color,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${suggestion.muscleGroups.length} grupos musculares',
                          style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.sports_gymnastics,
                        color: color,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${suggestion.exercises.length} exercícios',
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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

class _EquipmentCard extends StatelessWidget {
  final Equipment equipment;
  final Color color;

  const _EquipmentCard({required this.equipment, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color..withValues(alpha: (0.3))),
      ),
      child: Column(
        children: [
          if (equipment.imageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                equipment.imageUrl!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: (0.2)),
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.vertical(
                top: equipment.imageUrl != null
                    ? Radius.zero
                    : const Radius.circular(16),
                bottom: const Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: (0.2)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.fitness_center,
                        color: color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            equipment.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            equipment.description,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildSection(
                  'Grupos Musculares',
                  equipment.muscleGroups,
                  Icons.accessibility_new,
                  Colors.green,
                ),
                const SizedBox(height: 12),
                _buildSection(
                  'Exercícios',
                  equipment.exercises,
                  Icons.sports_gymnastics,
                  Colors.orange,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditEquipmentScreen(
                                equipment: equipment,
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: color,
                          side: BorderSide(color: color),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Editar'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/add-exercise',
                            arguments: equipment,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Adicionar Exercício',
                          style: TextStyle(color: BeShapeColors.textPrimary),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    String title,
    List<String> items,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                item,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
