import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class FoodDetailScreen extends StatelessWidget {
  final String foodImage;
  final String foodName;
  final String protein;
  final String carbs;
  final String fat;
  final String calories;
  const FoodDetailScreen(
      {super.key,
      required this.foodImage,
      required this.foodName,
      required this.protein,
      required this.carbs,
      required this.fat,
      required this.calories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildImageHeader(context),
            _buildRecipeDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageHeader(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: Image.network(
            foodImage,
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 40,
          left: 16,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        Positioned(
          top: 40,
          right: 16,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.black),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            foodName,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: BeShapeColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.timer, size: 16, color: Colors.grey),
              const SizedBox(width: 5),
              const Text("15 Min", style: TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "This Healthy Taco Salad is the universal delight of taco night",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 10),
          _buildNutritionInfo(),
          const SizedBox(height: 20),
          _buildIngredientsSection(),
          const SizedBox(height: 20),
          _buildCreatorSection(),
          const SizedBox(height: 20),
          _buildRelatedRecipes(),
        ],
      ),
    );
  }

  Widget _buildNutritionInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildNutritionItem(carbs, "Carbs"),
        _buildNutritionItem(protein, "Proteins"),
        _buildNutritionItem(calories, "Kcal"),
        _buildNutritionItem(fat, "Fats"),
      ],
    );
  }

  Widget _buildNutritionItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold,color: BeShapeColors.textPrimary)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildIngredientsSection() {
    final ingredients = [
      {"name": "Tortilla Chips", "quantity": 2, "icon": Icons.local_pizza},
      {"name": "Avocado", "quantity": 1, "icon": Icons.ac_unit},
      {"name": "Red Cabbage", "quantity": 9, "icon": Icons.circle},
      {"name": "Peanuts", "quantity": 1, "icon": Icons.spa},
      {"name": "Red Onions", "quantity": 1, "icon": Icons.food_bank},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Ingredients",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Column(
          children: ingredients
              .map((ingredient) => _buildIngredientItem(
                    ingredient["name"] as String,
                    ingredient["quantity"] as int,
                    ingredient["icon"] as IconData,
                  ))
              .toList(),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () {},
            child: const Text("Add To Cart", style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientItem(String name, int quantity, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal),
        title: Text(name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove, color: Colors.teal),
              onPressed: () {},
            ),
            Text(quantity.toString()),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.teal),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreatorSection() {
    return ListTile(
      leading: const CircleAvatar(
        backgroundImage:
            NetworkImage('https://source.unsplash.com/100x100/?woman,person'),
      ),
      title: const Text("Natalia Luca"),
      subtitle: const Text("I'm the author and recipe developer."),
    );
  }

  Widget _buildRelatedRecipes() {
    final recipes = [
      {
        "name": "Egg & Avocado",
        "image": "https://source.unsplash.com/100x100/?egg,avocado"
      },
      {
        "name": "Bowl of Rice",
        "image": "https://source.unsplash.com/100x100/?bowl,rice"
      },
      {
        "name": "Chicken Salad",
        "image": "https://source.unsplash.com/100x100/?chicken,salad"
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Related Recipes",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: recipes
                .map((recipe) => _buildRelatedRecipeItem(
                      recipe["name"] as String,
                      recipe["image"] as String,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRelatedRecipeItem(String name, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(imageUrl,
                width: 80, height: 80, fit: BoxFit.cover),
          ),
          const SizedBox(height: 5),
          Text(name, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
