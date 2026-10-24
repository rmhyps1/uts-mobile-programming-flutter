class MealItemModel {
  final String id;
  final String name;
  final String thumbnail;

  MealItemModel({
    required this.id,
    required this.name,
    required this.thumbnail,
  });

  factory MealItemModel.fromJson(Map<String, dynamic> json) {
    return MealItemModel(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      thumbnail: json['strMealThumb'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMeal': id,
      'strMeal': name,
      'strMealThumb': thumbnail,
    };
  }
}
