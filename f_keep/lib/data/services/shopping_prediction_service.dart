import '../../models/product_history_model.dart';

class ShoppingPredictionService {
  final double wastePenalty;
  final int historyDays;

  ShoppingPredictionService({this.wastePenalty = 0.5, this.historyDays = 7});

  int predictQty({
    required List<ProductHistory> history,
    required String productId,
    int planningDays = 3,
    int buffer = 1,
  }) {

     final cutoffDate =
        DateTime.now().subtract(Duration(days: historyDays)); //calculate based on prefer duration
    //filter history based on the period 
     final recentHistory = history
        .where((h) =>
            h.productId == productId &&
            h.dateChange.isAfter(cutoffDate))
        .toList();

    if (recentHistory.isEmpty) return 0;

    int totalEaten = 0;
    int totalWasted = 0;

    for (final h in recentHistory) {
      totalEaten += h.totalEaten;
      totalWasted += h.totalWasted;
    }

    // implement the predict logic
    final effectiveConsumption =
      totalEaten + (totalWasted * wastePenalty);

    final dailyAverage = effectiveConsumption / historyDays;

    final predicted =
        (dailyAverage * planningDays).ceil() + buffer;

    return predicted > 0 ? predicted : 0;
  }
}
