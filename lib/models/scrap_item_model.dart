import 'package:flutter/material.dart';

class ScrapItemModel {
  final String id;
  final String itemName;
  final String category;
  final double estimatedWeight;
  final int quantity;

  ScrapItemModel({
    this.id = '',
    required this.itemName,
    required this.category,
    required this.estimatedWeight,
    this.quantity = 1,
  });

  factory ScrapItemModel.fromJson(Map<String, dynamic> json) {
    return ScrapItemModel(
      id: json['id'] ?? '',
      itemName: json['item_name'] ?? '',
      category: json['category_name'] ?? '',
      estimatedWeight: (json['weight_kg'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_name': itemName,
      'category_name': category,
      'weight_kg': estimatedWeight,
      'quantity': quantity,
    };
  }

  ScrapItemModel copyWith({
    String? itemName,
    String? category,
    double? estimatedWeight,
    int? quantity,
  }) {
    return ScrapItemModel(
      id: id,
      itemName: itemName ?? this.itemName,
      category: category ?? this.category,
      estimatedWeight: estimatedWeight ?? this.estimatedWeight,
      quantity: quantity ?? this.quantity,
    );
  }

  static IconData getIconForCategory(String category) {
    final iconMap = {
      'Paper': Icons.description,
      'Plastic': Icons.inventory_2,
      'Metal': Icons.settings,
      'Glass': Icons.wine_bar,
      'E-Waste': Icons.devices,
      'Cardboard': Icons.view_in_ar,
    };
    return iconMap[category] ?? Icons.recycling;
  }
}
