class PriceEstimateModel {
  final String id;
  final String category;
  final double weight;
  final double pricePerKg;
  final double estimatedTotalValue;

  PriceEstimateModel({
    this.id = '',
    required this.category,
    required this.weight,
    required this.pricePerKg,
    required this.estimatedTotalValue,
  });

  factory PriceEstimateModel.fromJson(Map<String, dynamic> json) {
    return PriceEstimateModel(
      id: json['id'] ?? '',
      category: json['category_name'] ?? '',
      weight: (json['weight_kg'] ?? 0).toDouble(),
      pricePerKg: (json['price_per_kg'] ?? json['price_per_unit'] ?? 0).toDouble(),
      estimatedTotalValue: (json['estimated_total_value'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_name': category,
      'weight_kg': weight,
      'price_per_kg': pricePerKg,
      'estimated_total_value': estimatedTotalValue,
    };
  }
}
