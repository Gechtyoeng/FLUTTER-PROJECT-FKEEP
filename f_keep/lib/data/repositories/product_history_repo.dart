import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/product_history_model.dart';

class ProductHistoryRepository {
  static const _storageKey = 'product_history';

  /// Save history list
  Future<void> saveHistory(List<ProductHistory> historyList) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(historyList.map((h) => h.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  /// Load history list
  Future<List<ProductHistory>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString == null) return [];

    final jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList.map((json) => ProductHistory.fromJson(json)).toList();
  }

  /// Add single history record
  Future<void> addHistory(ProductHistory history) async {
    final historyList = await loadHistory();
    historyList.add(history);
    await saveHistory(historyList);
  }

  /// Clear all history
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
