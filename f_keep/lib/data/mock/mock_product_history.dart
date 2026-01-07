import '../../models/product_model.dart';
import '../../models/product_history_model.dart';
final mockProducts = [
  Product(
    productName: "Carrots",
    addedDate: DateTime.now().subtract(Duration(days: 3)),
    expireDate: DateTime.now().add(Duration(days: 4)),
    duration: 7,
    qty: 5,
    unit: Units.kg,
    category: Category.vegetable,
    status: ProductStatus.inFridge,
  ),
  Product(
    productName: "Chicken Breast",
    addedDate: DateTime.now().subtract(Duration(days: 1)),
    expireDate: DateTime.now().add(Duration(days: 2)),
    duration: 3,
    qty: 2,
    unit: Units.pack,
    category: Category.meat,
    status: ProductStatus.inFridge,
  ),
  Product(
    productName: "Apples",
    addedDate: DateTime.now().subtract(Duration(days: 5)),
    expireDate: DateTime.now().add(Duration(days: 10)),
    duration: 15,
    qty: 10,
    unit: Units.pcs,
    category: Category.fruit,
    status: ProductStatus.inFridge,
  ),
];


//mock history
final mockHistorys = [
  ProductHistory(
    productId: mockProducts[0].productId,
    dateChange: DateTime.now().subtract(Duration(days: 7)),
    totalEaten: 3,
    totalWasted: 1,
  ),
  ProductHistory(
    productId: mockProducts[1].productId,
    dateChange: DateTime.now().subtract(Duration(days: 2)),
    totalEaten: 1,
    totalWasted: 1,
  ),
  ProductHistory(
    productId: mockProducts[2].productId,
    dateChange: DateTime.now().subtract(Duration(days: 12)),
    totalEaten: 6,
    totalWasted: 0,
  ),
];
