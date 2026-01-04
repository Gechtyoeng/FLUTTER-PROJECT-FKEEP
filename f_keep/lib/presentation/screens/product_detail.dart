import 'package:flutter/material.dart';
import '../../models/product_model.dart';

class ProductDetail extends StatelessWidget {
  final Product product;
  const ProductDetail({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('this is product detail'));
  }
}
