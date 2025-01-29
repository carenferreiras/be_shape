// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _servingSizeController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinsController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatsController = TextEditingController();
  final _brandController = TextEditingController();
  final _searchController = TextEditingController();
  late TabController _tabController;
  String _selectedUnit = 'g';
  bool _isFavorite = false;
  bool _isPublic = false;
  bool _isCreatingNew = true;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<SavedFoodBloc>().add(const LoadUserSavedFoods());
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
            ),
            dialogBackgroundColor: const Color(0xFF303030),
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

  void _selectExistingFood(SavedFood food) {
    setState(() {
      _nameController.text = food.name;
      _caloriesController.text = food.calories.toString();
      _proteinsController.text = food.proteins.toString();
      _carbsController.text = food.carbs.toString();
      _fatsController.text = food.fats.toString();
      _brandController.text = food.brand ?? '';
      _servingSizeController.text = food.servingSize ?? '';
      _selectedUnit = food.servingUnit ?? 'g';
      _isCreatingNew = false;
      _isFavorite = false;
      _isPublic = food.isPublic;
    });
    
    _tabController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
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
      _isCreatingNew = true;
      _isFavorite = false;
      _isPublic = false;
    });
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
          servingSize: _servingSizeController.text.isEmpty ? null : _servingSizeController.text,
          servingUnit: _selectedUnit,
          isPublic: _isPublic,
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
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(onPressed: ()=> Navigator.pop(context), icon: Icon(Icons.arrow_back_ios,color: BeShapeColors.primary,)),
          title: const Text('Add Food', style: TextStyle(color: BeShapeColors.primary)),
          backgroundColor: Colors.black,
          elevation: 2,
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Create New'),
              Tab(text: 'My Foods'),
            ],
            indicatorColor: BeShapeColors.primary,
            labelColor: BeShapeColors.primary,
            unselectedLabelColor: Colors.grey,
          ),
          actions: [
            if (_isCreatingNew)
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: BeShapeColors.primary,
                ),
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                },
              ),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // Create New Tab
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[800]!),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Date: ${DateFormat('MMM d, yyyy').format(_selectedDate)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const Icon(
                              Icons.calendar_today,
                              color: BeShapeColors.primary,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _buildInputDecoration(
                        'Food Name',
                        Icons.restaurant_menu,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a food name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _brandController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _buildInputDecoration(
                        'Brand (optional)',
                        Icons.business,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _servingSizeController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.number,
                            decoration: _buildInputDecoration(
                              'Serving Size',
                              Icons.scale,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildUnitSelector(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _NutritionCard(
                      caloriesController: _caloriesController,
                      proteinsController: _proteinsController,
                      carbsController: _carbsController,
                      fatsController: _fatsController,
                    ),
                    if (_isFavorite) ...[
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text(
                          'Make Public',
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: const Text(
                          'Allow other users to see and use this food',
                          style: TextStyle(color: Colors.grey),
                        ),
                        value: _isPublic,
                        onChanged: (bool value) {
                          setState(() {
                            _isPublic = value;
                          });
                        },
                        activeColor: BeShapeColors.primary,
                      ),
                    ],
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submitFood,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BeShapeColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _isCreatingNew ? 'Add Food' : 'Add to Today',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: BeShapeColors.background
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // My Foods Tab
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search foods...',
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[800]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: BeShapeColors.primary),
                            ),
                            filled: true,
                            fillColor: Colors.grey[900],
                          ),
                          onChanged: _searchFoods,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, color: BeShapeColors.primary),
                        onPressed: () => Navigator.pushNamed(context, '/saved-food'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<SavedFoodBloc, SavedFoodState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Center(child: SpinKitThreeBounce(color: BeShapeColors.primary,));
                      }

                      if (state.foods.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.no_food,
                                size: 64,
                                color: Colors.grey[700],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No saved foods yet',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Save foods by marking them as favorites',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () => Navigator.pushNamed(context, '/saved-food'),
                                icon: const Icon(Icons.add),
                                label: const Text('Add New Food'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: BeShapeColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: state.foods.length,
                        itemBuilder: (context, index) {
                          final food = state.foods[index];
                          return Dismissible(
                            key: Key(food.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              color: Colors.red,
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (_) {
                              context.read<SavedFoodBloc>().add(DeleteSavedFood(food.id));
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                onTap: () => _selectExistingFood(food),
                                leading: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: food.photoUrl != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            food.photoUrl!,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.restaurant_menu,
                                                color: Colors.white,
                                              );
                                            },
                                          ),
                                        )
                                      : const Icon(
                                          Icons.restaurant_menu,
                                          color: Colors.white,
                                        ),
                                ),
                                title: Text(
                                  food.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (food.brand != null)
                                      Text(
                                        food.brand!,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    Text(
                                      'P: ${food.proteins.round()}g  C: ${food.carbs.round()}g  F: ${food.fats.round()}g',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Text(
                                  '${food.calories.round()} kcal',
                                  style: const TextStyle(
                                    color: BeShapeColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedUnit,
          dropdownColor: Colors.grey[900],
          style: const TextStyle(color: Colors.white),
          items: ['g', 'ml', 'oz', 'cup'].map((String unit) {
            return DropdownMenuItem<String>(
              value: unit,
              child: Text(unit),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedUnit = newValue;
              });
            }
          },
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
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
        borderSide: const BorderSide(color: BeShapeColors.primary),
      ),
      filled: true,
      fillColor: Colors.grey[900],
    );
  }

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
    super.dispose();
  }
}

class _NutritionCard extends StatelessWidget {
  final TextEditingController caloriesController;
  final TextEditingController proteinsController;
  final TextEditingController carbsController;
  final TextEditingController fatsController;

  const _NutritionCard({
    required this.caloriesController,
    required this.proteinsController,
    required this.carbsController,
    required this.fatsController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nutrition Facts',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildNutritionInput(
            'Calories',
            caloriesController,
            BeShapeColors.primary,
            'kcal',
          ),
          const SizedBox(height: 12),
          _buildNutritionInput(
            'Protein',
            proteinsController,
            Colors.blue,
            'g',
          ),
          const SizedBox(height: 12),
          _buildNutritionInput(
            'Carbs',
            carbsController,
            Colors.green,
            'g',
          ),
          const SizedBox(height: 12),
          _buildNutritionInput(
            'Fat',
            fatsController,
            Colors.red,
            'g',
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionInput(
    String label,
    TextEditingController controller,
    Color color,
    String unit,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            style: TextStyle(color: color),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              suffix: Text(
                unit,
                style: const TextStyle(color: Colors.grey),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: color.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: color),
              ),
              filled: true,
              fillColor: color.withOpacity(0.1),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}