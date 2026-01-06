import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/product_model.dart';

class ProductRepository {
  static const _storageKey = 'fridge_products';

  /// Save products list
  Future<void> saveProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(products.map((p) => p.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  /// Load products list
  Future<List<Product>> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString == null) return [];
    final jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((json) => Product.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Clear products
  Future<void> clearProducts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
