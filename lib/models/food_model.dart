/// Enterprise data model representing parsed nutritional evaluation metrics.
class FoodModel {
  final String foodName;
  final double calories;
  final double confidenceScore;
  final String accuracyStatus;
  final Map<String, String> macronutrients;

  FoodModel({
    required this.foodName,
    required this.calories,
    required this.confidenceScore,
    required this.accuracyStatus,
    required this.macronutrients,
  });

  /// Factory constructor to securely map incoming JSON objects into the data layer.
  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      foodName: json['foodName'] ?? 'Unknown Menu Item',
      calories: (json['calories'] ?? 0.0).toDouble(),
      confidenceScore: (json['confidenceScore'] ?? 0.0).toDouble(),
      accuracyStatus: json['accuracyStatus'] ?? 'Unverified',
      macronutrients: Map<String, String>.from(json['macronutrients'] ?? {}),
    );
  }
}