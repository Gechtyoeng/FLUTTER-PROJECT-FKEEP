import 'package:flutter/material.dart';
import '../../models/shopping_list_model.dart';

class ShoppingListDetail extends StatelessWidget {
  final ShoppingList shoppingList;
  const ShoppingListDetail({super.key, required this.shoppingList});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('this is shopping form'));
  }
}
