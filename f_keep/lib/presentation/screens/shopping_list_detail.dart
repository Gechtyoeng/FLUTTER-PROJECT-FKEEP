import 'package:f_keep/data/repositories/product_history_repo.dart';
import 'package:f_keep/data/repositories/product_repo.dart';
import 'package:f_keep/data/repositories/shopping_repo.dart';
import 'package:f_keep/data/services/shopping_generation_service.dart';
import 'package:f_keep/data/services/shopping_prediction_service.dart';
import 'package:flutter/material.dart';
import '../../models/shopping_list_model.dart';
import '../widgets/shopping_tile.dart';
import '../widgets/add_shopping_item.dart';
import '../../models/shopping_item_model.dart';
import '../../data/services/shopping_service.dart';
import '../widgets/share_widget.dart';

class ShoppingListDetail extends StatefulWidget {
  final ShoppingList shoppingList;
  const ShoppingListDetail({super.key, required this.shoppingList});

  @override
  State<ShoppingListDetail> createState() => _ShoppingListDetailState();
}

class _ShoppingListDetailState extends State<ShoppingListDetail> {
  late final ShoppingService shoppingService;

  @override
  void initState() {
    super.initState();
    shoppingService = ShoppingService(
      productRepo: ProductRepository(),
      historyRepo: ProductHistoryRepository(),
      shoppingRepo: ShoppingRepository(),
      generationService: ShoppingGenerationService(predictionService: ShoppingPredictionService()),
    );
  }

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
      await shoppingService.updateList(widget.shoppingList);
    }
  }

  void onEdit(int index) async {
    final editItem = widget.shoppingList.items[index];
    final result = await showModalBottomSheet<ShoppingItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return FractionallySizedBox(heightFactor: 0.6, child: AddShoppingItemBottomSheet(newItem: editItem));
      },
    );

    if (result != null) {
      setState(() {
        widget.shoppingList.items[index] = result;
      });
      await shoppingService.updateList(widget.shoppingList);
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
            shoppingItem: item,
            onDelete: () async {
              setState(() {
                widget.shoppingList.items.removeAt(index);
              });
              await shoppingService.addList(widget.shoppingList);
            },
            onEdit: () => onEdit(index),
            onChanged: (value) async {
              if (value == null) return;
              setState(() {
                item.isBought = value;
              });

              if (value) {
                // Show confirmation dialog final
                final shouldConvert = await showDialog<bool>(
                  context: context,
                  builder: (context) => ConfirmDialog(
                    title: "Add to Product List?",
                    message: "Do you want to add '${item.itemName}' to your product list?",
                    cancelText: "No",
                    confirmText: "Yes",
                    confirmColor: Theme.of(context).colorScheme.primary,
                  ),
                );
                if (shouldConvert == true) {
                  await shoppingService.convertItemToProduct(item);
                  setState(() {
                    widget.shoppingList.items.removeAt(index);
                  });
                } else {
                  await shoppingService.updateList(widget.shoppingList);
                }
              } else {
                await shoppingService.updateList(widget.shoppingList);
              }
            },
          );
        },
      ),
    );
  }
}
