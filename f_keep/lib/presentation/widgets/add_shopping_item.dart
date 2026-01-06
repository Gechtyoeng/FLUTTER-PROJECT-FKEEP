import 'package:f_keep/models/product_model.dart';
import 'package:f_keep/models/shopping_item_model.dart';
import 'package:f_keep/utils/validators.dart';
import 'package:flutter/material.dart';
import '../widgets/share_widget.dart';

class AddShoppingItemBottomSheet extends StatefulWidget {
  final ShoppingItem? newItem;

  const AddShoppingItemBottomSheet({super.key, this.newItem});

  @override
  State<AddShoppingItemBottomSheet> createState() => _AddShoppingItemBottomSheetState();
}

class _AddShoppingItemBottomSheetState extends State<AddShoppingItemBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _qtyController = TextEditingController();
  Category _selectedCategory = Category.fruit;
  Units _selectedUnit = Units.pack;

  @override
  void dispose() {
    _nameController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  void onAdd() async {
    if (_formKey.currentState!.validate()) {
      final shoppingItem = ShoppingItem(
        itemName: _nameController.text,
        qty: int.tryParse(_qtyController.text) ?? 0,
        unit: _selectedUnit,
        category: _selectedCategory,
        isBought: widget.newItem?.isBought ?? false,
      );
      Navigator.pop(context, shoppingItem);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.newItem != null) {
      _nameController.text = widget.newItem!.itemName;
      _qtyController.text = widget.newItem!.qty.toString();
      _selectedCategory = widget.newItem!.category;
      _selectedUnit = widget.newItem!.unit;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                    Text(widget.newItem == null ? "Add Shopping Item" : "Edit Shopping Item", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    TextButton(onPressed: onAdd, child: Text(widget.newItem == null ? "Add" : "Save")),
                  ],
                ),
                const SizedBox(height: 16),
                InputField(controller: _nameController, hintText: "Product Name", validator: validateName),
                const SizedBox(height: 12),
                InputField(controller: _qtyController, hintText: "Quantity", validator: validateQty),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: AppDropdown<Category>(
                        value: _selectedCategory,
                        items: Category.values,
                        hintText: "Select category",
                        labelBuilder: (c) => c.name,
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                        validator: (value) => value == null ? 'Please select a category' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppDropdown<Units>(
                        value: _selectedUnit,
                        items: Units.values,
                        hintText: "Unit",
                        labelBuilder: (u) => u.name,
                        onChanged: (value) {
                          setState(() {
                            _selectedUnit = value!;
                          });
                        },
                        validator: (value) => value == null ? 'Please select a unit' : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
