import 'package:f_keep/models/product_model.dart';
import 'package:f_keep/models/shopping_item_model.dart';
import 'package:flutter/material.dart';
import '../widgets/share_widget.dart';
class AddShoppingItemModal extends StatefulWidget {
  final ShoppingItem? newItem;

  const AddShoppingItemModal({super.key, this.newItem});

  @override
  State<AddShoppingItemModal> createState() => _AddShoppingItemModalState();
}

class _AddShoppingItemModalState extends State<AddShoppingItemModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _qtyController = TextEditingController();

  DateTime? _expiryDate;
  Category  _selectedCategory = Category.fruit;
  Units _selectedUnit = Units.pack;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Shopping Item"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Product Name"),
                validator: (value) => value == null || value.isEmpty ? "Enter product name" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _qtyController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Quantity"),
                validator: (value) => value == null || value.isEmpty ? "Enter quantity" : null,
              ),
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
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: Text(_expiryDate == null ? "No Expiry Date" : "Expiry: ${_expiryDate!.toLocal().toString().split(' ')[0]}")),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2100));
                      if (picked != null) {
                        setState(() => _expiryDate = picked);
                      }
                    },
                    child: const Text("Pick Date"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final shoppingItem = ShoppingItem(
                itemName: _nameController.text,
                qty: int.tryParse(_qtyController.text) ?? 0,
                unit: _selectedUnit,
                category: _selectedCategory,
              );
              Navigator.pop(context, shoppingItem);
            }
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}
