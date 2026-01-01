import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/models/shopping_list_model.dart';

class ShoppingRepository {
  static const _storageKey = 'shopping_list';

  /// Save shopping list to local storage
  Future<void> saveShoppingList(ShoppingList list) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(list.toJson());
    await prefs.setString(_storageKey, jsonString);
  }

  /// Load shopping list from local storage
  Future<ShoppingList?> loadShoppingList() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString == null) return null;
    final jsonMap = jsonDecode(jsonString);
    return ShoppingList.fromJson(jsonMap);
  }

  /// Clear shopping list
  Future<void> clearShoppingList() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
