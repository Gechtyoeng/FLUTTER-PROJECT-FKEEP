import '../repositories/product_repo.dart';
import '../repositories/product_history_repo.dart';
import '../repositories/shopping_repo.dart';
import '../services/shopping_generation_service.dart';
import '../../models/shopping_list_model.dart';

class ShoppingService {
  final ProductRepository productRepo;
  final ProductHistoryRepository historyRepo;
  final ShoppingRepository shoppingRepo;
  final ShoppingGenerationService generationService;

  ShoppingService({
    required this.productRepo,
    required this.historyRepo,
    required this.shoppingRepo,
    required this.generationService,
  });

  /// Load all shopping lists
  Future<List<ShoppingList>> loadLists() => shoppingRepo.loadLists();

  /// Save a new shopping list
  Future<void> addList(ShoppingList list) => shoppingRepo.saveList(list);

  /// Generate a smart shopping list
  Future<ShoppingList> generateSmartShoppingList() async {
    final products = await productRepo.loadProducts();
    final history = await historyRepo.loadHistory();
    return generationService.generateSmartFromHistory(
      history: history,
      products: products,
    );
  }
}
