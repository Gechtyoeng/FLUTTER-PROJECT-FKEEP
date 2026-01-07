import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/repositories/product_repo.dart';
import '../../models/product_model.dart';
import '../screens/product_form.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final String imagePath;
  final VoidCallback? onDeleted; // notify parent after deletion
  final ValueChanged<Product>? onUpdated; 

  const ProductCard({
    super.key,
    required this.product,
    required this.imagePath,
    this.onDeleted,
    this.onUpdated,
  });

  Future<void> _handleDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Are you sure to delete ${product.productName}?"),
          content: const Text(
            "You will lose this product after the confirmation.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.orange),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade200,
              ),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      final repo = ProductRepository();
      final products = await repo.loadProducts();
      products.removeWhere(
        (p) =>
            p.productName == product.productName &&
            p.addedDate == product.addedDate,
      );
      await repo.saveProducts(products);
      onDeleted?.call();
    }
  }

  Future<void> _handleEdit(BuildContext context) async {
    final Product? updatedProduct = await Navigator.of(context).push<Product>(
      MaterialPageRoute(builder: (_) => ProductForm(product: product)),
    );
    if (updatedProduct != null) {
      onUpdated?.call(updatedProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final subtitle = product.isExpired
        ? "Expired"
        : "${product.daysLeft} days more";

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _handleEdit(context), 
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(imagePath, fit: BoxFit.cover),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.productName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "${product.qty} ${product.unit.name}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => _handleDelete(context),
            ),
          ),
        ],
      ),
    );
  }
}
