import 'package:flutter/material.dart';

class ShoppingItemTile extends StatelessWidget {
  final String name;
  final String qty;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const ShoppingItemTile({
    super.key,
    required this.name,
    required this.qty,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                    decoration: isChecked ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: scheme.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  qty,
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          trailing: Checkbox(
            value: isChecked,
            onChanged: onChanged,
            activeColor: scheme.secondary,
          ),
        ),
        Divider(
          color: scheme.primary,
          thickness: 1,
          indent: 16,    
          endIndent: 16,
        ),
      ],
    );
  }
}
