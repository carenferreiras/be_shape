import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class AIAssistantCard extends StatelessWidget {
  const AIAssistantCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AIAssistantBloc, AIAssistantState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.suggestions.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Sugestões do AI Coach',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: state.suggestions.length,
                  itemBuilder: (context, index) {
                    return _SuggestionCard(
                      suggestion: state.suggestions[index],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final AISuggestion suggestion;

  const _SuggestionCard({
    required this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              _getPriorityColor(suggestion.priority).withValues(alpha: (0.3)),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showDetails(context),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getTypeColor(suggestion.type)
                            .withValues(alpha: (0.2)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        suggestion.icon,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            suggestion.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _getTypeText(suggestion.type),
                            style: TextStyle(
                              color: _getTypeColor(suggestion.type),
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
                        color: _getPriorityColor(suggestion.priority)
                            .withValues(alpha: (0.2)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getPriorityText(suggestion.priority),
                        style: TextStyle(
                          color: _getPriorityColor(suggestion.priority),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  suggestion.description,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                _buildPreview(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreview() {
    switch (suggestion.type) {
      case SuggestionType.nutrition:
        return _buildFoodsList();
      case SuggestionType.exercise:
        return _buildExercisesList();
      case SuggestionType.hydration:
      case SuggestionType.recovery:
        return _buildTipsList();
    }
  }

  Widget _buildFoodsList() {
    if (suggestion.foods == null || suggestion.foods!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: suggestion.foods!.take(3).map((food) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            food,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExercisesList() {
    if (suggestion.exercises == null || suggestion.exercises!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: suggestion.exercises!.take(2).map((exercise) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: BeShapeColors.link.withValues(alpha: (0.2)),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.fitness_center,
                  color: BeShapeColors.link,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      exercise.sets,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTipsList() {
    if (suggestion.tips == null || suggestion.tips!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: suggestion.tips!.take(2).map((tip) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: _getTypeColor(suggestion.type),
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  tip,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _SuggestionDetails(suggestion: suggestion),
    );
  }

  String _getTypeText(SuggestionType type) {
    switch (type) {
      case SuggestionType.nutrition:
        return 'Nutrição';
      case SuggestionType.exercise:
        return 'Exercício';
      case SuggestionType.hydration:
        return 'Hidratação';
      case SuggestionType.recovery:
        return 'Recuperação';
    }
  }

  Color _getTypeColor(SuggestionType type) {
    switch (type) {
      case SuggestionType.nutrition:
        return Colors.green;
      case SuggestionType.exercise:
        return BeShapeColors.link;
      case SuggestionType.hydration:
        return Colors.cyan;
      case SuggestionType.recovery:
        return Colors.purple;
    }
  }

  String _getPriorityText(Priority priority) {
    switch (priority) {
      case Priority.low:
        return 'Baixa';
      case Priority.medium:
        return 'Média';
      case Priority.high:
        return 'Alta';
    }
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.low:
        return BeShapeColors.success;
      case Priority.medium:
        return BeShapeColors.primary;
      case Priority.high:
        return BeShapeColors.error;
    }
  }
}

class _SuggestionDetails extends StatelessWidget {
  final AISuggestion suggestion;

  const _SuggestionDetails({
    required this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      _getTypeColor(suggestion.type).withValues(alpha: (0.2)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  suggestion.icon,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      suggestion.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _getTypeText(suggestion.type),
                      style: TextStyle(
                        color: _getTypeColor(suggestion.type),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            suggestion.description,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          _buildDetailedContent(),
        ],
      ),
    );
  }

  Widget _buildDetailedContent() {
    switch (suggestion.type) {
      case SuggestionType.nutrition:
        return _buildFoodsDetails();
      case SuggestionType.exercise:
        return _buildExercisesDetails();
      case SuggestionType.hydration:
      case SuggestionType.recovery:
        return _buildTipsDetails();
    }
  }

  Widget _buildFoodsDetails() {
    if (suggestion.foods == null || suggestion.foods!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Alimentos Recomendados',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...suggestion.foods!.map((food) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: (0.2)),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.restaurant,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      food,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildExercisesDetails() {
    if (suggestion.exercises == null || suggestion.exercises!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Exercícios Recomendados',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...suggestion.exercises!.map((exercise) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: BeShapeColors.link.withValues(alpha: (0.2)),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.fitness_center,
                          color: BeShapeColors.link,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exercise.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              exercise.sets,
                              style: const TextStyle(
                                color: BeShapeColors.link,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (exercise.tips.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'Dicas:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...exercise.tips.map((tip) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: BeShapeColors.link,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                tip,
                                style: TextStyle(
                                  color: Colors.grey[300],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTipsDetails() {
    if (suggestion.tips == null || suggestion.tips!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          suggestion.type == SuggestionType.hydration
              ? 'Dicas de Hidratação'
              : 'Dicas de Recuperação',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...suggestion.tips!.map((tip) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getTypeColor(suggestion.type)
                          .withValues(alpha: (0.2)),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      suggestion.type == SuggestionType.hydration
                          ? Icons.water_drop
                          : Icons.nightlight_round,
                      color: _getTypeColor(suggestion.type),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      tip,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  String _getTypeText(SuggestionType type) {
    switch (type) {
      case SuggestionType.nutrition:
        return 'Nutrição';
      case SuggestionType.exercise:
        return 'Exercício';
      case SuggestionType.hydration:
        return 'Hidratação';
      case SuggestionType.recovery:
        return 'Recuperação';
    }
  }

  Color _getTypeColor(SuggestionType type) {
    switch (type) {
      case SuggestionType.nutrition:
        return Colors.green;
      case SuggestionType.exercise:
        return BeShapeColors.link;
      case SuggestionType.hydration:
        return Colors.cyan;
      case SuggestionType.recovery:
        return Colors.purple;
    }
  }
}
