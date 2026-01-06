// import 'package:uuid/uuid.dart';

// /// Food categories
// enum Category { vegetable, meat, fruit, other }

// /// Product status
// enum ProductStatus { inFridge, eaten, wasted }

// /// Product units
// enum Units { grams, kg, pack, can, bags, pcs, loaf }

// class Product {
//   final String productId;
//   final String productName;
//   final DateTime addedDate;
//   final DateTime? expireDate;
//   final int? duration;
//   final int qty;
//   final Units unit;
//   final Category category;
//   final ProductStatus status;

//   Product({
//     String? productId,
//     required this.productName,
//     required this.addedDate,
//     this.expireDate,
//     this.duration,
//     required this.qty,
//     required this.unit,
//     required this.category,
//     required this.status,
//   }) : productId = productId ?? const Uuid().v4();

//   /// Deserialize from JSON
//   factory Product.fromJson(Map<String, dynamic> json) => Product(
//     productId: json['productId'],
//     productName: json['productName'],
//     addedDate: DateTime.parse(json['addedDate']),
//     expireDate: json['expireDate'] != null
//         ? DateTime.tryParse(json['expireDate'])
//         : null,
//     duration: json['duration'],
//     qty: json['qty'],
//     unit: Units.values.firstWhere(
//       (e) => e.name == json['unit'],
//       orElse: () => Units.pcs,
//     ),
//     category: Category.values.firstWhere(
//       (e) => e.name == json['category'],
//       orElse: () => Category.other,
//     ),
//     status: ProductStatus.values.firstWhere(
//       (e) => e.name == json['status'],
//       orElse: () => ProductStatus.inFridge,
//     ),
//   );

//   /// Serialize to JSON
//   Map<String, dynamic> toJson() => {
//     'productId': productId,
//     'productName': productName,
//     'addedDate': addedDate.toIso8601String(),
//     'expireDate': expireDate?.toIso8601String(),
//     'duration': duration,
//     'qty': qty,
//     'unit': unit.name,
//     'category': category.name,
//     'status': status.name,
//   };

//   int get daysLeft {
//     if (expireDate == null) return 0;
//     return expireDate!.difference(DateTime.now()).inDays;
//   }

//   String get displayQty => "$qty ${unit.name}";
//   String get displayCategory => category.name;

//   bool get isExpired {
//     if (expireDate == null) return false;
//     return expireDate!.isBefore(DateTime.now());
//   }

// }

import 'package:uuid/uuid.dart';

/// Food categories
enum Category { vegetable, meat, fruit, other }

/// Product status
enum ProductStatus { inFridge, eaten, wasted }

/// Product units
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
  }) : productId = productId ?? const Uuid().v4();

  /// Deserialize from JSON
  factory Product.fromJson(Map<String, dynamic> json) => Product(
    productId: json['productId'],
    productName: json['productName'],
    addedDate: DateTime.parse(json['addedDate']),
    expireDate: json['expireDate'] != null
        ? DateTime.tryParse(json['expireDate'])
        : null,
    duration: json['duration'],
    qty: json['qty'],
    unit: Units.values.firstWhere(
      (e) => e.name == json['unit'],
      orElse: () => Units.pcs,
    ),
    category: Category.values.firstWhere(
      (e) => e.name == json['category'],
      orElse: () => Category.other,
    ),
    status: ProductStatus.values.firstWhere(
      (e) => e.name == json['status'],
      orElse: () => ProductStatus.inFridge,
    ),
  );

  /// Serialize to JSON
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

  /// Days left until expiry
  int get daysLeft {
    if (expireDate == null) return 0;
    return expireDate!.difference(DateTime.now()).inDays;
  }

  /// Display helpers
  String get displayQty => "$qty ${unit.name}";
  String get displayCategory => category.name;

  /// Expiry check
  bool get isExpired {
    if (expireDate == null) return false;
    return expireDate!.isBefore(DateTime.now());
  }

  /// Computed status: if expired and not eaten, mark wasted
  ProductStatus get computedStatus {
    if (status == ProductStatus.eaten) return ProductStatus.eaten;
    if (isExpired) return ProductStatus.wasted;
    return ProductStatus.inFridge;
  }

  /// Copy with new values (useful for editing/updating)
  Product copyWith({
    String? productId,
    String? productName,
    DateTime? addedDate,
    DateTime? expireDate,
    int? duration,
    int? qty,
    Units? unit,
    Category? category,
    ProductStatus? status,
  }) {
    return Product(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      addedDate: addedDate ?? this.addedDate,
      expireDate: expireDate ?? this.expireDate,
      duration: duration ?? this.duration,
      qty: qty ?? this.qty,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      status: status ?? this.status,
    );
  }

  /// Mark product as eaten
  Product markEaten() => copyWith(status: ProductStatus.eaten);

  /// Mark product as wasted
  Product markWasted() => copyWith(status: ProductStatus.wasted);
}
