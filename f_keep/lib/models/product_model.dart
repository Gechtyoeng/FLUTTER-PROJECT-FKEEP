import 'package:uuid/uuid.dart';
//Enum classes for product model
// Food categories
enum Category { vegetable, meat, fruit, other }

//Product status
enum ProductStatus { inFridge, eaten, wasted}

//Product units
enum Units { grams, kg, pack, can, bags, pcs, loaf }


class Product {
  final String productId;
  final String productName;
  final DateTime addedDate;
  final DateTime? expireDate;
  final int? duration;
  final int qty;
  final Units unit;
  final Category category;
  final ProductStatus status;

  Product({
    String? productId,
    required this.productName,
    required this.addedDate,
    this.expireDate,   
    this.duration,     
    required this.qty,
    required this.unit,
    required this.category,
    required this.status,
  }): productId = productId ?? const Uuid().v4();

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json['productId'],
        productName: json['productName'],
        addedDate: DateTime.parse(json['addedDate']),
        expireDate: json['expireDate'] != null
            ? DateTime.tryParse(json['expireDate'])
            : null,
        duration: json['duration'], 
        qty: json['qty'],
        unit: Units.values.firstWhere((e) => e.name == json['unit']),
        category: Category.values.firstWhere((e) => e.name == json['category']),
        status: ProductStatus.values.firstWhere((e) => e.name == json['status']),
      );

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'productName': productName,
        'addedDate': addedDate.toIso8601String(),
        'expireDate': expireDate?.toIso8601String(),
        'duration': duration,
        'qty': qty,
        'unit': unit.name,
        'category': category.name,
        'status': status.name,
      };
}
