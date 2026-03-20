import '../models/price_estimate_model.dart';
import '../models/scrap_item_model.dart';

import 'api_service.dart';

class ScrapPriceService {
  final ApiService _apiService = ApiService();

  Future<PriceEstimateModel> calculateEstimateForCategory(
    String category,
    double weight,
  ) async {
    final response = await _apiService.estimateScrapPrice(category, weight);
    double pricePerKg = 0;
    double estimatedTotalValue = 0;

    if (response.containsKey('price_per_kg') &&
        response.containsKey('estimated_total')) {
      pricePerKg = double.tryParse(response['price_per_kg'].toString()) ?? 0.0;
      estimatedTotalValue =
          double.tryParse(response['estimated_total'].toString()) ?? 0.0;
    }

    return PriceEstimateModel(
      category: category,
      weight: weight,
      pricePerKg: pricePerKg,
      estimatedTotalValue: estimatedTotalValue,
    );
  }

  Future<List<PriceEstimateModel>> calculateEstimates(
    List<ScrapItemModel> items,
  ) async {
    List<PriceEstimateModel> estimates = [];
    for (var item in items) {
      final estimate = await calculateEstimateForCategory(
        item.category,
        item.estimatedWeight,
      );
      estimates.add(estimate);
    }
    return estimates;
  }

  double calculateTotal(List<PriceEstimateModel> estimates) {
    return estimates.fold(0.0, (sum, item) => sum + item.estimatedTotalValue);
  }
}
