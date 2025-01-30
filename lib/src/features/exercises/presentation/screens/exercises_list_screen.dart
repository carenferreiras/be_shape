import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../features.dart';
import '../../../../core/core.dart';

class ExerciseListScreen extends StatefulWidget {
  const ExerciseListScreen({super.key});

  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  late String userId;
  late DateTime _selectedDate; // Data selecionada no calendário
  late DateTime _focusedDate; // Data em foco no calendário

  @override
  void initState() {
    super.initState();
    _initializeUserId();
    _selectedDate = DateTime.now(); // Data inicial: hoje
    _focusedDate = DateTime.now(); // Foco inicial no calendário
    _loadExercisesForDate(_selectedDate); // Carrega exercícios do dia atual
  }

  void _initializeUserId() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      userId = currentUser.uid;
    } else {
      throw Exception('Usuário não autenticado');
    }
  }

  void _loadExercisesForDate(DateTime date) {
    context.read<ExerciseBloc>().add(LoadExercisesForUserAndDate(userId, date));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BeShapeNavigatorBar(index: 1),
      backgroundColor: Colors.black,
      appBar: const BeShapeAppBar(
        title: 'Exercícios',
        hasLeading: false,
      ),
      body: Column(
        children: [
          // Calendário
          _buildCalendar(),
          const SizedBox(height: 8),
          // Lista de exercícios
          Expanded(
            child: BlocBuilder<ExerciseBloc, ExerciseState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(
                    child: SpinKitThreeBounce(
                     color: BeShapeColors.primary,
                    ),
                  );
                }

                if (state.exercises.isEmpty) {
                  return const Center(
                    child: Text(
                      'No exercises found',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = state.exercises[index];

                    return Dismissible(
                      key: Key(exercise.id), // Chave única para cada item
                      direction: DismissDirection
                          .endToStart, // Permite arrastar apenas da direita para a esquerda
                      onDismissed: (direction) {
                        // Chama o evento de exclusão no Bloc
                        context
                            .read<ExerciseBloc>()
                            .add(DeleteExercise(exercise.id));

                        // Mostra uma mensagem de confirmação
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Exercício "${exercise.name}" excluído'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                      background: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Container(
                          // margin: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(16)),
                            border: Border.all(
                                width: 0.5,
                                color: BeShapeColors.primary.withOpacity(0.2)),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                      child: _ExerciseCard(
                        exercise: exercise,
                        onDelete: () {
                          // Pode ser usada para outras ações
                          context
                              .read<ExerciseBloc>()
                              .add(DeleteExercise(exercise.id));
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-exercise');
        },
        backgroundColor: BeShapeColors.primary,
        child: const Icon(
          Icons.add,
          color: BeShapeColors.background,
        ),
      ),
    );
  }

  /// Constrói o calendário para seleção de datas
  Widget _buildCalendar() {
    return TableCalendar(
      focusedDay: _focusedDate,
      firstDay: DateTime(2000),
      lastDay: DateTime(2100),
      calendarFormat: CalendarFormat.week,
      currentDay: DateTime.now(),
      selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDate = selectedDay;
          _focusedDate = focusedDay;
        });
        _loadExercisesForDate(
            selectedDay); // Atualiza exercícios da data selecionada
      },
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
        leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
        rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
      ),
      calendarStyle: CalendarStyle(
        selectedDecoration: const BoxDecoration(
          color: BeShapeColors.primary,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: BeShapeColors.primary.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        defaultTextStyle: const TextStyle(color: Colors.white),
        weekendTextStyle: const TextStyle(color: Colors.grey),
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onDelete;

  _ExerciseCard({
    required this.exercise,
    required this.onDelete,
  });

  final Map<String, String> _exerciseImages = {
    'Cardio': BeShapeImages.cardio,
    'Strength': BeShapeImages.strength,
    'Flexibility': BeShapeImages.flexibility,
    'Sports': BeShapeImages.sports,
    'Other': BeShapeImages.others,
  };

  @override
  Widget build(BuildContext context) {
    final imageUrl = _exerciseImages[exercise.type] ??
        'https://via.placeholder.com/300/CCCCCC/FFFFFF?text=Default';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: BeShapeColors.primary.withOpacity(0.4),
                  width: 0.5,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    child: Text(
                      exercise.type,
                      style: const TextStyle(
                        color: BeShapeColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    exercise.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    exercise.notes ?? '',
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoItem(
                        icon: Icons.timer,
                        label: '${exercise.duration} min',
                        color: BeShapeColors.primary,
                      ),
                      _buildInfoItem(
                        icon: Icons.local_fire_department,
                        label: '${exercise.caloriesBurned.round()} kcal',
                        color: BeShapeColors.primary,
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

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
