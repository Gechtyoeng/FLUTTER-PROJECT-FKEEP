import 'package:uuid/uuid.dart';

class ProductHistory {
  final String historyId;
  final String productId;
  final DateTime dateChange;
  final int totalEaten;
  final int totalWasted;

  ProductHistory({
    String? historyId,
    required this.productId,
    required this.dateChange,
    required this.totalEaten,
    required this.totalWasted,
  }) : historyId = historyId ?? const Uuid().v4();
}