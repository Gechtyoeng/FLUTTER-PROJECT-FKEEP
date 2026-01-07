import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/shopping_list_model.dart';

class ShoppingRepository {
  static const _storageKey = 'shopping_lists';

  /// Save single shopping list to local storage
  Future<void> saveList(ShoppingList list) async {
    final lists = await loadLists();
    lists.add(list);
    await saveAll(lists);
  }

  /// Load all shopping lists
  Future<List<ShoppingList>> loadLists() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString == null) return [];

    final List decoded = jsonDecode(jsonString);
    return decoded.map((e) => ShoppingList.fromJson(e)).toList();
  }

  /// Update existing shopping list by ID
  Future<void> updateList(ShoppingList list) async {
    final lists = await loadLists();
    final index = lists.indexWhere((l) => l.shoppingListId == list.shoppingListId);
    if (index != -1) {
      lists[index] = list;
    } else {
      lists.add(list);
    }
    await saveAll(lists);
  }

  /// Save all shopping lists
  Future<void> saveAll(List<ShoppingList> lists) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(lists.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  /// Clear all shopping lists
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
