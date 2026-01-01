import 'package:uuid/uuid.dart';
import 'product_history_model.dart';

class Analytics {
  final String analyticId;
  final Map<String, int> productConsumption;
  final int totalEaten;
  final int totalWasted;

  Analytics({
    String? analyticId,
    required this.productConsumption,
    required this.totalEaten,
    required this.totalWasted,
  }) : analyticId = analyticId ?? const Uuid().v4();

  factory Analytics.calculateFromHistory(List<ProductHistory> history) {
    int eaten = 0;
    int wasted = 0;
    Map<String, int> consumption = {};

    for (var h in history) {
      eaten += h.totalEaten;
      wasted += h.totalWasted;
      consumption[h.productId] =
          (consumption[h.productId] ?? 0) + h.totalEaten;
    }

    return Analytics(
      productConsumption: consumption,
      totalEaten: eaten,
      totalWasted: wasted,
    );
  }
}