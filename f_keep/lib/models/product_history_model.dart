import 'package:uuid/uuid.dart';

class ProductHistory {
  final String historyId;
  final String productId;
  final DateTime dateChange;
  final int totalEaten;
  final int totalWasted;

  ProductHistory({String? historyId, required this.productId, required this.dateChange, required this.totalEaten, required this.totalWasted})
    : historyId = historyId ?? const Uuid().v4();

  factory ProductHistory.fromJson(Map<String, dynamic> json) {
    return ProductHistory(
      historyId: json['historyId'],
      productId: json['productId'],
      dateChange: DateTime.parse(json['dateChange']),
      totalEaten: json['totalEaten'],
      totalWasted: json['totalWasted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'historyId': historyId, 'productId': productId, 'dateChange': dateChange.toIso8601String(), 'totalEaten': totalEaten, 'totalWasted': totalWasted};
  }
}
