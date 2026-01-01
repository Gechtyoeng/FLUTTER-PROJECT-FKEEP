import '../../model/enums/category.dart';
import '../../model/enums/units.dart';
import '../../model/enums/product_status.dart';
import '../../model/enums/shopping_status.dart';
import '../../model/models/product_history_model.dart';
import '../../model/models/product_model.dart';
import '../../model/models/shopping_item_model.dart';
import '../../model/models/shopping_list_model.dart';

/// Mock fridge products
final mockProducts = [
  Product(
    productName: "Pork",
    addedDate: DateTime.now().subtract(const Duration(days: 2)),
    expireDate: DateTime.now().add(const Duration(days: 2)),
    qty: 500,
    unit: Units.grams,
    category: Category.meat,
    status: ProductStatus.inFridge,
  ),
  Product(
    productName: "Coca-Cola",
    addedDate: DateTime.now().subtract(const Duration(days: 1)),
    expireDate: DateTime.now().add(const Duration(days: 5)),
    qty: 1,
    unit: Units.can,
    category: Category.other,
    status: ProductStatus.inFridge,
  ),
];

/// Mock shopping items
final mockShoppingItems = [
  ShoppingItem(
    itemName: "Milk",
    qty: 2,
    unit: Units.pack,
    status: ShoppingStatus.pending,
    category: Category.other,
  ),
  ShoppingItem(
    itemName: "Eggs",
    qty: 12,
    unit: Units.pcs,
    status: ShoppingStatus.purchased,
    category: Category.other,
  ),
  ShoppingItem(
    itemName: "Spinach",
    qty: 1,
    unit: Units.bags,
    status: ShoppingStatus.pending,
    category: Category.vegetable,
  ),
];

/// Mock shopping list
final mockShoppingList = ShoppingList(
  title: "Weekly Groceries",
  items: mockShoppingItems,
);

/// Mock product history
final mockHistory = [
  ProductHistory(
    productId: mockProducts[0].productId,
    dateChange: DateTime.now().subtract(const Duration(days: 1)),
    totalEaten: 10,
    totalWasted: 0,
  ),
  ProductHistory(
    productId: mockProducts[1].productId,
    dateChange: DateTime.now(),
    totalEaten: 0,
    totalWasted: 1,
  ),
];
