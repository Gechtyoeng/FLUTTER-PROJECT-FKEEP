import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/product_model.dart';
import 'package:uuid/uuid.dart';
import '../../utils/validators.dart';
import '../widgets/share_widget.dart';

final newProductId = Uuid().v4();

class ProductForm extends StatefulWidget {
  final Product? product; //no product for create new
  const ProductForm({super.key, this.product});

  bool get isEdit => product != null;

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  //controllers
  late TextEditingController _nameController;
  late TextEditingController _qtyController;
  late TextEditingController _dateController;
  late Category category;
  late Units unit;

  //form key
  final _formKey = GlobalKey<FormState>();

  //default setting for product
  static const defaultName = 'Food';
  static const defaultQty = 1;
  static const defaultCategory = Category.other;
  static const defaultUnit = Units.bags;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.isEdit ? widget.product!.productName : defaultName);

    _qtyController = TextEditingController(text: widget.isEdit ? widget.product!.qty.toString() : defaultQty.toString());

    _dateController = TextEditingController(text: widget.isEdit ? _formatDate(widget.product!.addedDate) : _formatDate(DateTime.now()));

    category = widget.isEdit ? widget.product!.category : defaultCategory;

    unit = widget.isEdit ? widget.product!.unit : defaultUnit;
  }

  @override
  void dispose() {
    super.dispose();
    // dispose the controlers
    _nameController.dispose();
    _dateController.dispose();
    _qtyController.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  //when reset the form
  void onReset() {
    setState(() {
      _nameController.text = widget.isEdit ? widget.product!.productName : defaultName;

      _qtyController.text = widget.isEdit ? widget.product!.qty.toString() : defaultQty.toString();

      _dateController.text = widget.isEdit ? _formatDate(widget.product!.addedDate) : _formatDate(DateTime.now());

      // Reset dropdowns
      category = widget.isEdit ? widget.product!.category : defaultCategory;
      unit = widget.isEdit ? widget.product!.unit : defaultUnit;
    });
  }

  //create new product
  void onSubmit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final product = Product(
      productName: _nameController.text,
      addedDate: DateTime.now(),
      qty: int.parse(_qtyController.text),
      unit: unit,
      category: category,
      status: ProductStatus.inFridge,
    );

    Navigator.pop(context, product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEdit ? 'Edit Product' : 'Create Product',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onPrimary),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.fromLTRB(25, 12, 25, 12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  InputField(controller: _nameController, hintText: 'Product Name', validator: validateName),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: InputField(controller: _qtyController, hintText: 'Product Qty', validator: validateQty),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppDropdown<Units>(
                          value: unit,
                          items: Units.values,
                          hintText: "Unit",
                          labelBuilder: (u) => u.name,
                          onChanged: (value) {
                            setState(() {
                              unit = value!;
                            });
                          },
                          validator: (value) => value == null ? 'Please select a unit' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  InputField(controller: _dateController, hintText: 'Select a Date', isDate: true, validator: validateDate),
                  const SizedBox(height: 12),
                  AppDropdown<Category>(
                    value: category,
                    items: Category.values,
                    hintText: "Select category",
                    labelBuilder: (c) => c.name,
                    onChanged: (value) {
                      setState(() {
                        category = value!;
                      });
                    },
                    validator: (value) => value == null ? 'Please select a category' : null,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: AppButton(label: "Reset product", onPressed: onReset, backgroundColor: const Color.fromARGB(1, 158, 154, 156)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(label: "Save Product", onPressed: onSubmit),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
