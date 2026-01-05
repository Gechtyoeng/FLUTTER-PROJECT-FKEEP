import 'package:f_keep/presentation/widgets/add_shopping_item.dart';
import 'package:flutter/material.dart';
import '../../models/shopping_list_model.dart';
import '../../models/shopping_item_model.dart';
import '../widgets/share_widget.dart';
import '../../data/mock/mocks_data.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  ShoppingStatus _currentFilter = ShoppingStatus.progess;

  void onCreate() async {
    ShoppingList? newShoppingList = await Navigator.of(context).push<ShoppingList>(MaterialPageRoute(builder: (context) => const AddShoppingItemModal()));

    if (newShoppingList != null) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Shopping",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
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
      body: Padding(
        padding: const EdgeInsetsGeometry.fromLTRB(25, 12, 25, 12),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                // implement generate list later
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 50,
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star_border, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 12),
                    const Text('Generate shopping List', style: TextStyle(fontWeight: FontWeight.normal)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Shopping List', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    for (final status in ShoppingStatus.values) ...[
                      FilterButton(buttonText: status.name, isSelected: _currentFilter == status, onTap: () => setState(() => _currentFilter = status)),
                      const SizedBox(width: 12),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            ShoppingListTile(shoppingList: mockShoppingList),
            ShoppingListTile(shoppingList: mockShoppingList),
          ],
        ),
      ),
    );
  }
}

class ShoppingListTile extends StatelessWidget {
  final ShoppingList shoppingList;
  const ShoppingListTile({super.key, required this.shoppingList});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          title: Text(shoppingList.title ?? 'shoppingList', style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onPrimary)),
          trailing: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary, borderRadius: BorderRadius.circular(4)),
            child: const Text('Pending', style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ),
      ),
    );
  }
}
