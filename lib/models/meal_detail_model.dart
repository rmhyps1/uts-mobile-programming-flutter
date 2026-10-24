class IngredientItem {
  final String name;
  final String measure;

  IngredientItem({
    required this.name,
    required this.measure,
  });
}

class MealDetailModel {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbnail;
  final String youtubeUrl;
  final List<IngredientItem> ingredients;

  MealDetailModel({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnail,
    required this.youtubeUrl,
    required this.ingredients,
  });

  factory MealDetailModel.fromJson(Map<String, dynamic> json) {
    List<IngredientItem> extractedIngredients = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null &&
          ingredient is String &&
          ingredient.trim().isNotEmpty) {
        extractedIngredients.add(
          IngredientItem(
            name: ingredient.trim(),
            measure: (measure != null && measure is String)
                ? measure.trim()
                : '',
          ),
        );
      }
    }

    return MealDetailModel(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      category: json['strCategory'] ?? 'Umum',
      area: json['strArea'] ?? json['strCountry'] ?? 'Internasional',
      instructions: json['strInstructions'] ?? 'Petunjuk memasak tidak tersedia.',
      thumbnail: json['strMealThumb'] ?? '',
      youtubeUrl: json['strYoutube'] ?? '',
      ingredients: extractedIngredients,
    );
  }
}
