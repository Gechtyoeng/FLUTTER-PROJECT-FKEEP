import 'package:uuid/uuid.dart';
import 'product_model.dart';

class ShoppingItem {
  final String shoppingItemId;
  final String itemName;
  final int qty;
  final Units unit;
  //ShoppingStatus status;
  final Category category;
  bool isBought;

  ShoppingItem({String? shoppingItemId, required this.itemName, required this.qty, required this.unit, required this.isBought, required this.category})
    : shoppingItemId = shoppingItemId ?? const Uuid().v4();

  //bool get isBought => status == ShoppingStatus.purchased;

  // add ShoppingItem to Product when purchased
  Product toProduct() {
    return Product(productName: itemName, addedDate: DateTime.now(), qty: qty, unit: unit, category: category, status: ProductStatus.inFridge);
  }

  factory ShoppingItem.fromJson(Map<String, dynamic> json) => ShoppingItem(
    shoppingItemId: json['shoppingItemId'],
    itemName: json['itemName'],
    qty: json['qty'],
    unit: Units.values.firstWhere((e) => e.name == json['unit']),
    isBought: json['isBought'],
    category: Category.values.firstWhere((e) => e.name == json['category']),
  );
  
  Map<String, dynamic> toJson() => {
    'shoppingItemId': shoppingItemId,
    'itemName': itemName,
    'qty': qty,
    'unit': unit.name,
    //'status': status.name,
    'category': category.name,
  };
}
