class ScrapItemModel {
  final String itemName;
  final String category;
  final double estimatedWeight;
  final double estimatedPrice;
  final int quantity;

  ScrapItemModel({
    required this.itemName,
    required this.category,
    required this.estimatedWeight,
    required this.estimatedPrice,
    required this.quantity,
  });
}
