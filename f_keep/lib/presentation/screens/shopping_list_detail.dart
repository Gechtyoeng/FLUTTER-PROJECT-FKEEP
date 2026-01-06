import 'package:flutter/material.dart';
import '../../models/shopping_list_model.dart';
import '../widgets/shopping_tile.dart';
import '../widgets/add_shopping_item.dart';
import '../../models/shopping_item_model.dart';

class ShoppingListDetail extends StatefulWidget {
  final ShoppingList shoppingList;
  const ShoppingListDetail({super.key, required this.shoppingList});

  @override
  State<ShoppingListDetail> createState() => _ShoppingListDetailState();
}

class _ShoppingListDetailState extends State<ShoppingListDetail> {
  void onCreate() async {
    final result = await showModalBottomSheet<ShoppingItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return FractionallySizedBox(heightFactor: 0.6, child: AddShoppingItemBottomSheet());
      },
    );
    if (result != null) {
      setState(() {
        widget.shoppingList.items.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.shoppingList.title!,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onPrimary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton.filled(
              color: Colors.white,
              onPressed: onCreate,
              icon: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
              style: IconButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.onPrimary, shape: const CircleBorder()),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.shoppingList.items.length,
        itemBuilder: (context, index) {
          final item = widget.shoppingList.items[index];
          return ShoppingItemTile(
            name: item.itemName,
            qty: item.qty.toString(),
            isChecked: item.isBought,
            onChanged: (value) {
              setState(() {
                item.isBought = !item.isBought;
              });
            },
          );
        },
      ),
    );
  }
}
