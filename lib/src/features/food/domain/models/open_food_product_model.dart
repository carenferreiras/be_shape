import 'package:uuid/uuid.dart';

class FoodProduct {
  final String id;
  final String name;
  final String brand;
  final String imageUrl;
  final String ingredients;
  final String allergens;
  final double energy;
  final double proteins;
  final double carbohydrates;
  final double sugars;
  final double fats;
  final double saturatedFats;
  final double fiber;
  final double salt;
  final String nutriScore;
  final String labels;
  final String? category;

  FoodProduct({
    required this.id,
    required this.name,
    required this.brand,
    required this.imageUrl,
    required this.ingredients,
    required this.allergens,
    required this.energy,
    required this.proteins,
    required this.carbohydrates,
    required this.sugars,
    required this.fats,
    required this.saturatedFats,
    required this.fiber,
    required this.salt,
    required this.nutriScore,
    required this.labels,
    this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'allergens': allergens,
      'energy': energy,
      'proteins': proteins,
      'carbohydrates': carbohydrates,
      'sugars': sugars,
      'fats': fats,
      'saturatedFats': saturatedFats,
      'fiber': fiber,
      'salt': salt,
      'nutriScore': nutriScore,
      'labels': labels,
      'category': category,
    };
  }

  factory FoodProduct.fromJson(Map<String, dynamic> json) {
    final product = json.containsKey('product') ? json['product'] : json;
    final nutriments =
        product.containsKey('nutriments') ? product['nutriments'] : {};

    return FoodProduct(
      id: product['id'] ??
          "${product['product_name']}-${product['brands']}-${const Uuid().v4()}",
      name: product['product_name']?.toString().trim() ?? 'Sem Nome',
      brand: product['brands']?.toString().trim() ?? 'Sem Marca',
      imageUrl: product['image_url'] ??
          'https://via.placeholder.com/100', // Imagem padrão se não houver
      ingredients: product['ingredients_text']?.toString().trim() ??
          'Ingredientes não informados',
      allergens: product['allergens']?.toString().trim() ??
          'Nenhum alérgeno informado',
      energy: nutriments['energy-kcal_100g']?.toDouble() ?? -1,
      proteins: nutriments['proteins_100g']?.toDouble() ?? -1,
      carbohydrates: nutriments['carbohydrates_100g']?.toDouble() ?? -1,
      sugars: nutriments['sugars_100g']?.toDouble() ?? -1,
      fats: nutriments['fat_100g']?.toDouble() ?? -1,
      saturatedFats: nutriments['saturated-fat_100g']?.toDouble() ?? -1,
      fiber: nutriments['fiber_100g']?.toDouble() ?? -1,
      salt: nutriments['salt_100g']?.toDouble() ?? -1,
      nutriScore:
          product['nutriscore_grade']?.toString().toUpperCase() ?? 'N/A',
      labels: product['labels']?.toString().trim() ?? 'Sem rótulos',
      category: product['category']?.toString().trim() ?? 'N/A',
    );
  }
}
