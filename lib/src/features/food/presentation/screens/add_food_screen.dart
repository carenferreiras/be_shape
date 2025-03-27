// ignore_for_file: unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class AddFoodScreen extends StatefulWidget {
  final Map<String, dynamic>? initialFoodData;

  const AddFoodScreen({super.key, this.initialFoodData});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _servingSizeController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinsController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatsController = TextEditingController();
  final _brandController = TextEditingController();
  final _searchController = TextEditingController();
  final _fibersController = TextEditingController();
  final _classificationController = TextEditingController();
  final _sodiumController = TextEditingController();
  final _waterController = TextEditingController();
  final _ironController = TextEditingController();
  final _calciumController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  double baseCalories = 0.0;
  double baseProteins = 0.0;
  double baseCarbs = 0.0;
  double baseFibers = 0.0;
  double baseFat = 0.0;
  double baseSodium = 0.0;
  double baseCalcium = 0.0;
  double baseIron = 0.0;
  double baseWater = 0.0;

  late TabController _tabController;
  String _selectedUnit = 'g';
  bool _isFavorite = false;
  bool _isPublic = false;
  bool _isCreatingNew = true;

  DateTime _selectedDate = DateTime.now();
  List<Map<String, dynamic>> allAlimentos = [];
  List<Map<String, dynamic>> alimentosFiltrados = [];
  List<String> classificacoes = [];

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _servingSizeController.dispose();
    _caloriesController.dispose();
    _proteinsController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    _brandController.dispose();
    _searchController.dispose();
    _quantityController.removeListener(_updateNutritionValues);
    _quantityController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 4, vsync: this); // Atualize para o número correto de abas
    context.read<SavedFoodBloc>().add(const LoadUserSavedFoods());
    if (widget.initialFoodData != null) {
      _preFillFoodData(widget.initialFoodData!);
    }
    _loadFoodsFromDatabase();
  }

  void _preFillFoodData(Map<String, dynamic> food) {
    setState(() {
      _nameController.text = food['nome_alimento'] ?? '';
      _brandController.text = food['marca'] ?? '';
      baseCalories = safeParseDouble(food['caloria']);
      baseProteins = safeParseDouble(food['proteina']);
      baseCarbs = safeParseDouble(food['carboidrato']);
      baseFat = safeParseDouble(food['gordura']);
      baseFibers = safeParseDouble(food['fibra']);
      baseSodium = safeParseDouble(food['sodio']);
      baseIron = safeParseDouble(food['ferro']);
      baseCalcium = safeParseDouble(food['calcio']);
      baseWater = safeParseDouble(food['agua']);
      _isCreatingNew = false;
      _updateNutritionValues();
    });
  }
  // void _loadFoodsFromDatabase() async {
  //   final querySnapshot =
  //       await FirebaseFirestore.instance.collection('foods').get();
  //   setState(() {
  //     allAlimentos = querySnapshot.docs.map((doc) => doc.data()).toList();
  //     alimentosFiltrados = List.from(allAlimentos);
  //   });
  // }

  void _loadFoodsFromDatabase() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('foods').get();
    setState(() {
      allAlimentos = querySnapshot.docs.map((doc) => doc.data()).toList();
      alimentosFiltrados = List.from(allAlimentos);

      classificacoes = allAlimentos
          .map<String?>((food) => food['categoria'] as String?)
          .where((c) => c != null)
          .toSet()
          .cast<String>()
          .toList();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: BeShapeColors.primary,
              onPrimary: Colors.white,
              surface: Color(0xFF303030),
              onSurface: Colors.white,
            ), dialogTheme: DialogThemeData(backgroundColor: const Color(0xFF303030)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Função auxiliar para tratar valores numéricos
  double safeParseDouble(dynamic value) {
    if (value == null || value == 'NA') return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  void _selectExistingFood(SavedFood food) {
    setState(() {
      _nameController.text = food.name;
      _caloriesController.text = food.calories.toString();
      _proteinsController.text = food.proteins.toString();
      _carbsController.text = food.carbs.toString();
      _fatsController.text = food.fats.toString();
      _brandController.text = food.brand ?? '';
      _calciumController.text = food.calsium.toString();
      _sodiumController.text = food.sodium.toString();
      _fibersController.text = food.fiber.toString();
      _ironController.text = food.iron.toString();
      _waterController.text = food.water.toString();
      _servingSizeController.text = food.servingSize ?? '';
      _selectedUnit = food.servingUnit ?? 'g';
      _isCreatingNew = false;
      _isFavorite = false;
      _isPublic = food.isPublic;
    });

    _tabController.animateTo(0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _updateNutritionValues() {
    final quantityText = _quantityController.text;
    final quantity =
        (quantityText.isEmpty) ? 1.0 : double.tryParse(quantityText) ?? 1.0;

    setState(() {
      _caloriesController.text = (baseCalories * quantity).toStringAsFixed(2);
      _proteinsController.text = (baseProteins * quantity).toStringAsFixed(2);
      _carbsController.text = (baseCarbs * quantity).toStringAsFixed(2);
      _fibersController.text = (baseFibers * quantity).toStringAsFixed(2);
      _waterController.text = (baseWater * quantity).toStringAsFixed(2);
      _ironController.text = (baseIron * quantity).toStringAsFixed(2);
      _calciumController.text = (baseCalcium * quantity).toStringAsFixed(2);
      _sodiumController.text = (baseSodium * quantity).toStringAsFixed(2);
      _fatsController.text = (baseFat * quantity).toStringAsFixed(2);
    });
  }

  void _clearForm() {
    setState(() {
      _nameController.clear();
      _servingSizeController.clear();
      _caloriesController.clear();
      _proteinsController.clear();
      _carbsController.clear();
      _fatsController.clear();
      _brandController.clear();
      _waterController.clear();
      _ironController.clear();
      _calciumController.clear();
      _sodiumController.clear();
      _fibersController.clear();
      _isCreatingNew = true;
      _isFavorite = false;
      _isPublic = false;
    });
  }

  void _selectFoodFromDatabase(Map<String, dynamic> food) {
    setState(() {
      _nameController.text = food['nome_alimento'] ?? '';
      baseCalories = safeParseDouble(food['caloria']);
      baseProteins = safeParseDouble(food['proteina']);
      baseCarbs = safeParseDouble(food['carboidrato']);
      baseFibers = safeParseDouble(food['fibra']);
      baseFat = safeParseDouble(food['gordura']);
      baseSodium = safeParseDouble(food['sodio']);
      baseCalcium = safeParseDouble(food['calcio']);
      baseIron = safeParseDouble(food['ferro']);
      baseWater = safeParseDouble(food['agua']);
      _classificationController.text = food['categoria'] ?? '';
      _quantityController.text = '1';
      _updateNutritionValues();
    });
    _tabController.animateTo(0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _submitFood() async {
    if (_formKey.currentState!.validate()) {
      final userId = context.read<AuthRepository>().currentUser?.uid;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated')),
        );
        return;
      }

      final meal = Meal(
        id: DateTime.now().toString(),
        userId: userId,
        name: _nameController.text,
        calories: double.parse(_caloriesController.text),
        proteins: double.parse(_proteinsController.text),
        carbs: double.parse(_carbsController.text),
        fats: double.parse(_fatsController.text),
        date: DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          DateTime.now().hour,
          DateTime.now().minute,
        ),
        isSaved: false,
      );

      if (_isFavorite) {
        final savedFood = SavedFood(
          id: DateTime.now().toString(),
          userId: userId,
          name: _nameController.text,
          calories: double.parse(_caloriesController.text),
          proteins: double.parse(_proteinsController.text),
          carbs: double.parse(_carbsController.text),
          fats: double.parse(_fatsController.text),
          brand: _brandController.text.isEmpty ? null : _brandController.text,
          servingSize: _servingSizeController.text.isEmpty
              ? null
              : _servingSizeController.text,
          servingUnit: _selectedUnit,
          isPublic: _isPublic,
          water: double.parse(_waterController.text),
          calsium: double.parse(_calciumController.text),
          sodium: double.parse(_sodiumController.text),
          iron: double.parse(_ironController.text),
          fiber: double.parse(_fibersController.text),
        );

        context.read<SavedFoodBloc>().add(AddSavedFood(savedFood));
      }

      context.read<MealBloc>().add(AddMeal(meal));
      Navigator.pop(context);
    }
  }

  void _searchFoods(String query) {
    if (query.isEmpty) {
      context.read<SavedFoodBloc>().add(const LoadUserSavedFoods());
    } else {
      context.read<SavedFoodBloc>().add(SearchSavedFoods(query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(BeShapeImages.foodBackground),
                fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: BeShapeColors.primary,
                )),
            title: const Text('Add Food',
                style: TextStyle(color: BeShapeColors.primary)),
            backgroundColor: Colors.black.withValues(alpha: (0.7)),
            elevation: 2,
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Novo Alimento'),
                Tab(text: 'Alimentos'),
                Tab(text: 'Meus Alimentos'),
                Tab(text: 'Favoritos'),
              ],
              indicatorColor: BeShapeColors.primary,
              labelColor: BeShapeColors.primary,
              unselectedLabelColor: Colors.grey,
            ),
            actions: [
              IconButton(
                  onPressed: () => _tabController.animateTo(3),
                  icon: Icon(
                    Icons.favorite,
                    color: BeShapeColors.primary,
                  ))
            ],
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              // Create New Tab
              SingleChildScrollView(
                child: Column(
                  children: [
                    CreateNewTabWidget(
                      nameController: _nameController,
                      brandController: _brandController,
                      servingSizeController: _servingSizeController,
                      quantityController: _quantityController,
                      caloriesController: _caloriesController,
                      proteinsController: _proteinsController,
                      carbsController: _carbsController,
                      fatsController: _fatsController,
                      formKey: _formKey,
                      isFavorite: _isFavorite,
                      isPublic: _isPublic,
                      isCreatingNew: _isCreatingNew,
                      selecteDate: _selectedDate,
                      selectDatetap: () => _selectDate(context),
                      isPubliconChanged: (bool value) {
                        setState(() {
                          _isPublic = value;
                        });
                      },
                      submitFoodPressed: _submitFood,
                      updateNutritionValues: (_) => _updateNutritionValues(),
                      fibersController: _fibersController,
                      sodiumController: _sodiumController,
                      calciumController: _calciumController,
                      ironController: _ironController,
                      waterController: _waterController,
                      fat: baseFat,
                      carbs: baseCarbs,
                      protein: baseProteins,
                    ),
                  ],
                ),
              ),
              // App Foods Tab
              OpenFoodFactsScreen(),

              // My Foods Tab
              Column(
                children: [
                  SearchMyFoodTab(
                      onChanged: _searchFoods,
                      searchController: _searchController),
                  Expanded(
                    child: BlocBuilder<SavedFoodBloc, SavedFoodState>(
                      builder: (context, state) {
                        if (state.isLoading) {
                          return const Center(
                              child: SpinKitWaveSpinner(
                            color: BeShapeColors.primary,
                          ));
                        }
                        if (state.foods.isEmpty) {
                          return EmptyListComponent(
                            title: 'Nenhum Alimento Encontrado',
                            subTitle:
                                'Adicione novos alimentos a sua lista, e salve-os',
                            buttonText: 'Adicionar',
                          );
                        }

                        return ListView.builder(
                          itemCount: state.foods.length,
                          itemBuilder: (context, index) {
                            final food = state.foods[index];
                            return MyFoodsCardTab(
                                onDismissed: (_) {
                                  context
                                      .read<SavedFoodBloc>()
                                      .add(DeleteSavedFood(food.id));
                                },
                                onTapSelectExistingFood: () =>
                                    _selectExistingFood(food),
                                dimissibleKey: Key(food.id),
                                food: food);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              FavoriteFoodsScreen()
            ],
          ),
        ),
      ),
    );
  }
}
