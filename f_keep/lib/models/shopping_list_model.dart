import 'package:uuid/uuid.dart';
import 'shopping_item_model.dart';

class ShoppingList {
  final String shoppingListId;
  final String? title;
  final List<ShoppingItem> items;

  ShoppingList({String? shoppingListId, this.title, required this.items})
    : shoppingListId = shoppingListId ?? const Uuid().v4();

 // bool get allPurchased => items.every((item) => item.isBought);

  // List<Product> toProducts() {
  //   return items
  //       .where((item) => item.isBought)
  //       .map((item) => item.toProduct())
  //       .toList();
  // }

  // JSON serialization
  factory ShoppingList.fromJson(Map<String, dynamic> json) => ShoppingList(
    shoppingListId: json['shoppingListId'],
    title: json['title'],
    items: (json['items'] as List<dynamic>)
        .map((item) => ShoppingItem.fromJson(item))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'shoppingListId': shoppingListId,
    'title': title,
    'items': items.map((item) => item.toJson()).toList(),
  };
}
