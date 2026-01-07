import '../../data/repositories/product_repo.dart';
import '../../models/product_model.dart';

class ProductService {
  final ProductRepository _repository;

  ProductService({required ProductRepository repository}) : _repository = repository;

  /// Load all products
  Future<List<Product>> loadProducts() async {
    return await _repository.loadProducts();
  }

  /// Save products
  Future<void> saveProducts(List<Product> products) async {
    await _repository.saveProducts(products);
  }

  /// Add a new product and persist
  Future<List<Product>> addProduct(List<Product> products, Product product) async {
    products.add(product);
    await saveProducts(products);
    return products;
  }

  /// Update an existing product and persist
  Future<List<Product>> updateProduct(List<Product> products, Product updatedProduct) async {
    final idx = products.indexWhere((p) => p.productId == updatedProduct.productId);
    if (idx != -1) {
      products[idx] = updatedProduct;
      await saveProducts(products);
    }
    return products;
  }

  /// Delete product and persist
  Future<List<Product>> deleteProduct(List<Product> products, Product product) async {
    products.removeWhere((p) => p.productId == product.productId);
    await saveProducts(products);
    return products;
  }

  /// Count products by status
  int countByStatus(List<Product> products, ProductStatus status) {
    return products.where((p) => p.computedStatus == status).length;
  }

  /// Get nearly expired products
  List<Product> getNearlyExpired(List<Product> products) {
    return products.where((p) {
      if (p.expireDate == null) return false;
      final daysLeft = p.expireDate!.difference(DateTime.now()).inDays;
      return daysLeft <= 3 && p.computedStatus == ProductStatus.inFridge;
    }).toList();
  }

  /// Map category to image path
  String imageForCategory(Category category) {
    switch (category) {
      case Category.meat:
        return "assets/images/Meat.jpg";
      case Category.vegetable:
        return "assets/images/Vegetable.jpg";
      case Category.fruit:
        return "assets/images/Fruit.jpg";
      default:
        return "assets/images/Fruit.jpg";
    }
  }
}
