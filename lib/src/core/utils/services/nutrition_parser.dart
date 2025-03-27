class NutritionParser {
  static Map<String, String> extractNutritionalData(String text) {
    Map<String, String> nutritionData = {};

    RegExp exp = RegExp(
      r"(Calorias|Proteínas|Carboidratos|Gorduras|Açúcares|Fibras):?\s*([\d.,]+)\s*(kcal|g|mg)?",
      caseSensitive: false,
    );

    for (var match in exp.allMatches(text)) {
      String key = match.group(1)!.trim();
      String value = match.group(2)!.trim();
      nutritionData[key] = value;
    }

    return nutritionData;
  }
}