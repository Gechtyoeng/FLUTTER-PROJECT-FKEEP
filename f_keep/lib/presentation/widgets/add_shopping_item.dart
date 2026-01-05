import 'package:flutter/material.dart';

class AddShoppingItemModal extends StatefulWidget {
  final void Function(String name, DateTime? expiry, int qty, String category, String unit) onAdd;

  const AddShoppingItemModal({super.key, required this.onAdd});

  @override
  State<AddShoppingItemModal> createState() => _AddShoppingItemModalState();
}

class _AddShoppingItemModalState extends State<AddShoppingItemModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _qtyController = TextEditingController();

  DateTime? _expiryDate;
  String _selectedCategory = "Fruit";
  String _selectedUnit = "Pack";

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
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      items: ["Fruit", "Meat", "Vegetable", "Can"].map((c) {
                        return DropdownMenuItem(value: c, child: Text(c));
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedCategory = val!),
                      decoration: const InputDecoration(labelText: "Category"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedUnit,
                      items: ["Pack", "Bag", "Can"].map((u) {
                        return DropdownMenuItem(value: u, child: Text(u));
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedUnit = val!),
                      decoration: const InputDecoration(labelText: "Unit"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(_expiryDate == null
                        ? "No Expiry Date"
                        : "Expiry: ${_expiryDate!.toLocal().toString().split(' ')[0]}"),
                  ),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
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
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onAdd(
                _nameController.text,
                _expiryDate,
                int.tryParse(_qtyController.text) ?? 0,
                _selectedCategory,
                _selectedUnit,
              );
              Navigator.pop(context);
            }
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}
