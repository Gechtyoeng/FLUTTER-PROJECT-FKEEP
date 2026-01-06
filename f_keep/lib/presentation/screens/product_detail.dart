import 'package:flutter/material.dart';
import '../../models/product_model.dart';

class ProductDetail extends StatelessWidget {
  final Product product;
  const ProductDetail({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.productName),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Quantity: ${product.qty} ${product.unit.name}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Text(
              product.expireDate != null
                  ? "Expires: ${product.expireDate}"
                  : "No expiry date",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text("Category: ${product.category.name}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Text("Status: ${product.status.name}",
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
