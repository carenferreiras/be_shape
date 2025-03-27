import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../features.dart';

class SupplementsScreen extends StatefulWidget {
  const SupplementsScreen({super.key});

  @override
  State<SupplementsScreen> createState() => _SupplementsScreenState();
}

class _SupplementsScreenState extends State<SupplementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSupplements();
  }

  void _loadSupplements() {
    final userId = context.read<AuthBloc>().currentUserId;
    if (userId != null) {
      context.read<SupplementBloc>().add(LoadUserSupplements(userId));
      context.read<SupplementBloc>().add(LoadActiveSupplements(userId));
      context.read<SupplementBloc>().add(LoadLowSupplements(userId));
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
        title: const Text('Suplementação'),
        backgroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Ativos'),
            Tab(text: 'Histórico'),
            Tab(text: 'Alertas'),
          ],
          indicatorColor: Colors.purple,
          labelColor: Colors.purple,
          unselectedLabelColor: Colors.grey,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ActiveSupplementsTab(),
          _HistoryTab(),
          _AlertsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddSupplementScreen(),
            ),
          ).then((_) => _loadSupplements());
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ActiveSupplementsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupplementBloc, SupplementState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final activeSupplements =
            state.supplements.where((s) => s.isActive).toList();

        if (activeSupplements.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: (0.2)),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.medication,
                    color: Colors.purple,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Nenhum suplemento ativo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Adicione seus suplementos para começar',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: activeSupplements.length,
          itemBuilder: (context, index) {
            return _SupplementCard(
              supplement: activeSupplements[index],
            );
          },
        );
      },
    );
  }
}

class _HistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupplementBloc, SupplementState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final logs = state.logs;
        if (logs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: (0.2)),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.history,
                    color: Colors.purple,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Nenhum histórico disponível',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Registre seus suplementos diariamente',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // Agrupar logs por data
        final groupedLogs = <String, List<SupplementLog>>{};
        for (final log in logs) {
          final date = DateFormat('dd/MM/yyyy').format(log.takenAt);
          groupedLogs.putIfAbsent(date, () => []).add(log);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: groupedLogs.length,
          itemBuilder: (context, index) {
            final date = groupedLogs.keys.elementAt(index);
            final dayLogs = groupedLogs[date]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...dayLogs.map((log) => _LogCard(log: log)),
                const SizedBox(height: 16),
              ],
            );
          },
        );
      },
    );
  }
}

class _AlertsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupplementBloc, SupplementState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final lowSupplements =
            state.supplements.where((s) => s.isRunningLow).toList();

        if (lowSupplements.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: (0.2)),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.orange,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Nenhum alerta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Todos os suplementos estão em dia',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: lowSupplements.length,
          itemBuilder: (context, index) {
            return _AlertCard(
              supplement: lowSupplements[index],
            );
          },
        );
      },
    );
  }
}

class _SupplementCard extends StatelessWidget {
  final Supplement supplement;

  const _SupplementCard({required this.supplement});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple..withValues(alpha: (0.3))),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.withValues(alpha: (0.2)),
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: (0.2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.medication,
                    color: Colors.purple,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        supplement.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        supplement.brand,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: (0.2)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getTypeText(supplement.type),
                    style: const TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildInfoItem(
                      'Dosagem',
                      '${supplement.dosage} ${supplement.unit.toString().split('.').last}',
                      Icons.scale,
                    ),
                    const SizedBox(width: 24),
                    _buildInfoItem(
                      'Horários',
                      supplement.scheduledTimes
                          .map((t) => DateFormat('HH:mm').format(t))
                          .join(', '),
                      Icons.access_time,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfoItem(
                      'Dias',
                      supplement.daysOfWeek.entries
                          .where((e) => e.value)
                          .map((e) => e.key.substring(0, 3).toUpperCase())
                          .join(', '),
                      Icons.calendar_today,
                    ),
                    const SizedBox(width: 24),
                    _buildInfoItem(
                      'Restante',
                      '${supplement.daysRemaining} dias',
                      Icons.timer,
                      color: supplement.isRunningLow ? Colors.orange : null,
                    ),
                  ],
                ),
                if (supplement.notes != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Notas',
                          style: TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          supplement.notes!,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // TODO: Implementar edição
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.purple,
                          side: const BorderSide(color: Colors.purple),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Editar'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<SupplementBloc>().add(
                                LogSupplementTaken(
                                  SupplementLog(
                                    id: DateTime.now().toString(),
                                    userId: supplement.userId,
                                    supplementId: supplement.id,
                                    takenAt: DateTime.now(),
                                    dosage: supplement.dosage,
                                    unit: supplement.unit
                                        .toString()
                                        .split('.')
                                        .last,
                                  ),
                                ),
                              );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Tomar'),
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

  Widget _buildInfoItem(
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    color ??= Colors.grey[400]!;

    return Expanded(
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTypeText(SupplementType type) {
    switch (type) {
      case SupplementType.protein:
        return 'Proteína';
      case SupplementType.creatine:
        return 'Creatina';
      case SupplementType.bcaa:
        return 'BCAA';
      case SupplementType.preworkout:
        return 'Pré-treino';
      case SupplementType.vitamin:
        return 'Vitamina';
      case SupplementType.mineral:
        return 'Mineral';
      case SupplementType.omega3:
        return 'Ômega 3';
      case SupplementType.other:
        return 'Outro';
    }
  }
}

class _LogCard extends StatelessWidget {
  final SupplementLog log;

  const _LogCard({required this.log});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple..withValues(alpha: (0.3))),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: (0.2)),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.purple,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('HH:mm').format(log.takenAt),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (log.notes != null)
                  Text(
                    log.notes!,
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
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: (0.2)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${log.dosage} ${log.unit}',
              style: const TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  final Supplement supplement;

  const _AlertCard({required this.supplement});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange..withValues(alpha: (0.3))),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange.withValues(alpha: (0.2)),
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: (0.2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.warning,
                    color: Colors.orange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        supplement.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Restam ${supplement.daysRemaining} dias',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: supplement.daysRemaining / supplement.daysSupply,
                  backgroundColor: Colors.grey[800],
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Comprado em: ${DateFormat('dd/MM/yyyy').format(supplement.startDate)}',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BuyAgainScreen(
                              supplement: supplement,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      icon: const Icon(Icons.shopping_cart, size: 16),
                      label: const Text('Comprar'),
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
}
