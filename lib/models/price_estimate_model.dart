class PriceEstimateModel {
  final String category;
  final double weight;
  final double pricePerKg;
  final double estimatedTotalValue;

  PriceEstimateModel({
    required this.category,
    required this.weight,
    required this.pricePerKg,
    required this.estimatedTotalValue,
  });
}
