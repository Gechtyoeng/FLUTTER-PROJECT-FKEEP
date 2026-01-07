import 'package:f_keep/models/shopping_list_model.dart';
import 'package:flutter/material.dart';
import '../widgets/share_widget.dart';
import 'package:f_keep/utils/validators.dart';

class AddShoppingListBottomsheet extends StatefulWidget {
  final ShoppingList? shoppingList;
  const AddShoppingListBottomsheet({super.key, this.shoppingList});

  @override
  State<AddShoppingListBottomsheet> createState() => _AddShoppingListBottomsheetState();
}

class _AddShoppingListBottomsheetState extends State<AddShoppingListBottomsheet> {
  final _nameController = TextEditingController();
  static const defaultListName = 'shopping List';

  @override
  void initState() {
    super.initState();
    _nameController.text = defaultListName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void onAdd() async {
    final newShoppingList = ShoppingList(title: _nameController.text, items: []);
    Navigator.pop(context, newShoppingList);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                    const Text("Add Shopping List", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    TextButton(onPressed: onAdd, child: const Text("Add")),
                  ],
                ),
                const SizedBox(height: 16),
                InputField(controller: _nameController, hintText: "Shopping list titile", validator: validateName),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
