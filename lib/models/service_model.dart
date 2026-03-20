import 'package:flutter/material.dart';

class ServiceModel {
  final String name;
  final IconData icon;
  final String description;
  final String estimatedDuration;
  final double startingPrice;

  final String category;

  ServiceModel({
    required this.name,
    required this.icon,
    required this.description,
    required this.estimatedDuration,
    required this.startingPrice,
    required this.category,
  });
}
