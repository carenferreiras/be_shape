import 'package:be_shape_app/src/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../features.dart';

class OpenFoodFactsScreen extends StatefulWidget {
  OpenFoodFactsScreen({super.key});

  @override
  _OpenFoodFactsScreenState createState() => _OpenFoodFactsScreenState();
}

class _OpenFoodFactsScreenState extends State<OpenFoodFactsScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  bool _isLoading = true; 

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: SpinKitWaveSpinner(
            color: BeShapeColors.primary,
          )) 
        : SingleChildScrollView(
            child: Column(
              children: [
                _buildFoodSearchTab(),
              ],
            ),
          );
  }

  Widget _buildFoodSearchTab() {
    return Column(
      children: [
        SearchMyFoodTab(
          searchController: _searchController,
          onPressed: () {
            final query = _searchController.text;
            if (query.isNotEmpty) {
              context.read<OpenFoodFactsBloc>().add(SearchFoodsEvent(query));
            }
          },
        ),
        BlocBuilder<OpenFoodFactsBloc, OpenFoodFactsState>(
          builder: (context, state) {
            if (state is OpenFoodFactsLoading) {
              return const Center(
                  child: SpinKitWaveSpinner(color: BeShapeColors.primary));
            } else if (state is OpenFoodFactsLoaded) {
              return _buildFoodList(state.foods);
            } else if (state is OpenFoodFactsError) {
              return Center(
                  child: EmptyListComponent(
                      icon: Icons.error,
                      title: 'Erro',
                      subTitle:
                          'Estamos com problemas para conectar a lista de alimentos, verifique sua conexão.'));
            }
            return const EmptyListComponent(
                icon: Icons.search,
                title: 'Pesquise um alimento',
                subTitle:
                    'Digite no campo de pesquisa e clique no botão para pesquisar.');
          },
        ),
      ],
    );
  }

  Widget _buildFoodList(List<FoodProduct> foods) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: foods.length,
      itemBuilder: (context, index) {
        final FoodProduct food = foods[index];
        final isFavorite = context
            .watch<FavoriteFoodBloc>()
            .state
            .favoriteFoods
            .contains(food);

        return CustomCard(
          cardOnTap: () => _navigateToAddFood(context, food),
          caloriesIcon: Icons.water_drop_outlined,
          calories: '${safeParseDouble(food.energy).toStringAsFixed(2)}',
          carbo: '${safeParseDouble(food.carbohydrates).toStringAsFixed(2)}',
          proteinIcon: Icons.fitness_center,
          fibersIcon: Icons.fiber_smart_record,
          fibers: '${safeParseDouble(food.fiber).toStringAsFixed(2)}',
          foodName: food.name,
          classification: food.brand,
          data: {},
          fatIcon: Icons.water_drop,
          protein: '${safeParseDouble(food.proteins).toStringAsFixed(2)}',
          fat: '${safeParseDouble(food.fats).toStringAsFixed(2)}',
          sodium: '${safeParseDouble(food.saturatedFats).toStringAsFixed(2)}',
          qnt: '0',
          water: '${safeParseDouble(food.sugars).toStringAsFixed(2)}',
          iron: '',
          calcium: '',
          onPressed: () {
            if (isFavorite) {
              context.read<FavoriteFoodBloc>().add(RemoveFavoriteFood(food));
            } else {
              context.read<FavoriteFoodBloc>().add(AddFavoriteFood(food));
            }
          },
          favoriteColorIcon:
              isFavorite ? const Color.fromARGB(255, 233, 20, 5) : null,
          favoriteIcon: isFavorite ? Icons.favorite : Icons.favorite_border,
          image: food.imageUrl,
        );
      },
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
