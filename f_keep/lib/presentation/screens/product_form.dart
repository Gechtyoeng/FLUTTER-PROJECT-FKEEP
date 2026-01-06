import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../models/product_model.dart';
import '../../utils/validators.dart';
import '../widgets/share_widget.dart';

class ProductForm extends StatefulWidget {
  final Product? product;
  const ProductForm({super.key, this.product});

  bool get isEdit => product != null;

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  late TextEditingController _nameController;
  late TextEditingController _qtyController;
  late TextEditingController _dateController;
  late Category category;
  late Units unit;

  final _formKey = GlobalKey<FormState>();

  static const defaultName = 'Food';
  static const defaultQty = 1;
  static const defaultCategory = Category.fruit;
  static const defaultUnit = Units.bags;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.isEdit ? widget.product!.productName : defaultName,
    );

    _qtyController = TextEditingController(
      text: widget.isEdit
          ? widget.product!.qty.toString()
          : defaultQty.toString(),
    );

    _dateController = TextEditingController(
      text: widget.isEdit && widget.product!.expireDate != null
          ? _formatDate(widget.product!.expireDate!)
          : _formatDate(DateTime.now().add(const Duration(days: 5))),
    );

    category = widget.isEdit ? widget.product!.category : defaultCategory;
    unit = widget.isEdit ? widget.product!.unit : defaultUnit;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void onReset() {
    setState(() {
      _nameController.text = widget.isEdit
          ? widget.product!.productName
          : defaultName;
      _qtyController.text = widget.isEdit
          ? widget.product!.qty.toString()
          : defaultQty.toString();
      _dateController.text = widget.isEdit && widget.product!.expireDate != null
          ? _formatDate(widget.product!.expireDate!)
          : _formatDate(DateTime.now().add(const Duration(days: 7)));
      category = widget.isEdit ? widget.product!.category : defaultCategory;
      unit = widget.isEdit ? widget.product!.unit : defaultUnit;
    });
  }

  void onSubmit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    DateTime? expire;
    try {
      expire = DateTime.parse(_dateController.text);
    } catch (_) {
      expire = null;
    }

    final product = Product(
      productId: widget.isEdit ? widget.product!.productId : const Uuid().v4(),
      productName: _nameController.text,
      addedDate: widget.isEdit ? widget.product!.addedDate : DateTime.now(),
      expireDate: expire,
      qty: int.tryParse(_qtyController.text) ?? 0,
      unit: unit,
      category: category,
      status: widget.isEdit ? widget.product!.status : ProductStatus.inFridge,
    );

    context.pop(product);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEdit ? 'Edit Product' : 'Create Product',
          style: TextStyle(
            color: scheme.onPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: scheme.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: scheme.onPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 12, 25, 12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  InputField(
                    controller: _nameController,
                    hintText: 'Product Name',
                    validator: validateName,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: InputField(
                          controller: _qtyController,
                          hintText: 'Product Qty',
                          validator: validateQty,
                        ),
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
                          validator: (value) =>
                              value == null ? 'Please select a unit' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  InputField(
                    controller: _dateController,
                    hintText: 'Expire Date (YYYY-MM-DD)',
                    isDate: true,
                    validator: validateDate,
                  ),
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
                    validator: (value) =>
                        value == null ? 'Please select a category' : null,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: widget.isEdit ? "Reset changes" : "Reset product",
                      onPressed: onReset,
                      backgroundColor: const Color.fromARGB(255, 158, 154, 156),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      label: widget.isEdit ? "Save Changes" : "Save Product",
                      onPressed: onSubmit,
                    ),
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
