import 'package:uuid/uuid.dart';
import 'product_model.dart';
import 'shopping_item_model.dart';

//Enum for shopping status
enum ShoppingStatus { progress, pending, purchased }

class ShoppingList {
  final String shoppingListId;
  final String? title;
  final List<ShoppingItem> items;

  ShoppingList({String? shoppingListId, this.title, required this.items}) : shoppingListId = shoppingListId ?? const Uuid().v4();

 // get the shopping status based on items
 ShoppingStatus get status { 
  if (items.isEmpty) return ShoppingStatus.pending; 
  final allPurchased = items.every((item) => item.isBought); 
  final nonePurchased = items.every((item) => !item.isBought); 
  if (allPurchased) return ShoppingStatus.purchased; 
  if (nonePurchased) return ShoppingStatus.pending; 
  return ShoppingStatus.progress; 
  }
  List<Product> toProducts() {
    return items.where((item) => item.isBought).map((item) => item.toProduct()).toList();
  }

  // JSON serialization
  factory ShoppingList.fromJson(Map<String, dynamic> json) =>
    ShoppingList(shoppingListId: json['shoppingListId'], title: json['title'], items: (json['items'] as List<dynamic>).map((item) => ShoppingItem.fromJson(item)).toList());

  Map<String, dynamic> toJson() => {'shoppingListId': shoppingListId, 'title': title, 'items': items.map((item) => item.toJson()).toList()};
}
