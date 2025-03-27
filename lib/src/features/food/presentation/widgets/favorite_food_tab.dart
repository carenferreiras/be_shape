import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../core/core.dart';
import '../../../features.dart';

class FavoriteFoodsScreen extends StatefulWidget {
  const FavoriteFoodsScreen({super.key});

  @override
  _FavoriteFoodsScreenState createState() => _FavoriteFoodsScreenState();
}

class _FavoriteFoodsScreenState extends State<FavoriteFoodsScreen> {
  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    context.read<FavoriteFoodBloc>().add(LoadFavoriteFoods());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alimentos Favoritos')),
      body: BlocBuilder<FavoriteFoodBloc, FavoriteFoodState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
                child: SpinKitWaveSpinner(
              color: BeShapeColors.primary,
            ));
          }

          if (state.favoriteFoods.isEmpty) {
            return const Center(
                child: EmptyListComponent(
                    title: 'Nenhum Alimento Favorito',
                    subTitle: 'Adicione alimentos à sua lista de favoritos.'));
          }

          return ListView.builder(
            itemCount: state.favoriteFoods.length,
            itemBuilder: (context, index) {
              final food = state.favoriteFoods[index];

              return CustomCard(
                cardOnTap: () => _navigateToAddFood(context, food),
                caloriesIcon: Icons.water_drop_outlined,
                calories: '${safeParseDouble(food.energy).toStringAsFixed(2)}',
                carbo:
                    '${safeParseDouble(food.carbohydrates).toStringAsFixed(2)}',
                proteinIcon: Icons.fitness_center,
                fibersIcon: Icons.fiber_smart_record,
                fibers: '${safeParseDouble(food.fiber).toStringAsFixed(2)}',
                foodName: food.name,
                classification: food.brand,
                data: {},
                fatIcon: Icons.water_drop,
                protein: '${safeParseDouble(food.proteins).toStringAsFixed(2)}',
                fat: '${safeParseDouble(food.fats).toStringAsFixed(2)}',
                sodium:
                    '${safeParseDouble(food.saturatedFats).toStringAsFixed(2)}',
                qnt: '0',
                water: '${safeParseDouble(food.sugars).toStringAsFixed(2)}',
                iron: '',
                calcium: '',
                onPressed: () => context
                    .read<FavoriteFoodBloc>()
                    .add(RemoveFavoriteFood(food)),
                favoriteColorIcon: BeShapeColors.error,
                favoriteIcon: Icons.delete,
                image: food.imageUrl,
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToAddFood(BuildContext context, FoodProduct food) {
    final foodData = {
      'nome_alimento': food.name,
      'caloria': food.energy,
      'proteina': food.proteins,
      'carboidrato': food.carbohydrates,
      'gordura': food.fats,
      'fibra': food.fiber,
      'sodio': food.salt,
      'ferro': food.sugars,
      'calcio': food.saturatedFats,
      'agua': food.salt,
      'marca': food.brand,
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddFoodScreen(initialFoodData: foodData),
      ),
    );
  }

  double safeParseDouble(dynamic value) {
    if (value == null || value == 'NA') return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}
