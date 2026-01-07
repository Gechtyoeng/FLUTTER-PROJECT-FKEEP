import '../../models/shopping_list_model.dart';
import '../../models/shopping_item_model.dart';
import '../../models/product_model.dart';
import '../../models/product_history_model.dart';
import 'shopping_prediction_service.dart';

class ShoppingGenerationService {
  final ShoppingPredictionService predictionService;

  ShoppingGenerationService({required this.predictionService});

  ShoppingList generateSmartFromHistory({required List<ProductHistory> history, required List<Product> products}) {
    final List<ShoppingItem> items = [];

    for (final product in products) {
      final predictedQty = predictionService.predictQty(history: history, productId: product.productId);

      if (predictedQty <= 0) continue;

      items.add(ShoppingItem(itemName: product.productName, qty: predictedQty, unit: product.unit, category: product.category, isBought: false));
    }

    return ShoppingList(title: 'Smart Shopping List', items: items);
  }
}
