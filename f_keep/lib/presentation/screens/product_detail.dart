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
            // Expire Date
            Text(
              product.expireDate != null
                  ? "Expire Date: ${product.expireDate}"
                  : "Expire Date: N/A",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),

            // Added Date
            Text(
              '',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),

            // Quantity Left
            Text(
              "Quantity: ${product.qty} ${product.unit.name} Left",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
