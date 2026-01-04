import 'package:flutter/material.dart';
import '../../models/product_model.dart';

class ProductForm extends StatelessWidget {
  final Product? product;
  const ProductForm({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('this is product form'));
  }
}
