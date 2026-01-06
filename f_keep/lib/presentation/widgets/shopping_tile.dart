import 'package:f_keep/models/shopping_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../widgets/share_widget.dart';

class ShoppingItemTile extends StatelessWidget {
  final ShoppingItem shoppingItem;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ShoppingItemTile({super.key, required this.shoppingItem, required this.onChanged, required this.onDelete, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Slidable(
      key: ValueKey(shoppingItem.shoppingItemId),
      endActionPane: ActionPane(
        motion: DrawerMotion(),
        children: [
          SlidableAction(onPressed: (_) => onEdit(), backgroundColor: scheme.secondary, foregroundColor: Colors.white, icon: Icons.edit, label: 'Edit'),
          SlidableAction(
            onPressed: (_) async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) =>
                    ConfirmDialog(title: 'Delete Item', message: 'Do you really want to delete "${shoppingItem.itemName}"?', confirmText: 'Delete', confirmColor: Colors.red),
              );
              if (confirm == true) {
                onDelete();
              }
            },
            backgroundColor: scheme.error,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    shoppingItem.itemName,
                    style: TextStyle(fontWeight: FontWeight.w600, color: scheme.onSurface, decoration: shoppingItem.isBought ? TextDecoration.lineThrough : null),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: scheme.secondary, borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    shoppingItem.qty.toString(),
                    style: TextStyle(fontSize: 12, color: scheme.onSecondary, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            trailing: Checkbox(value: shoppingItem.isBought, onChanged: onChanged, activeColor: scheme.secondary),
          ),
          Divider(color: scheme.primary, thickness: 1, indent: 16, endIndent: 16),
        ],
      ),
    );
  }
}
