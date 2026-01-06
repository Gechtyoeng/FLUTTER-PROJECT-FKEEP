import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/repositories/product_repo.dart';
import '../../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final String imagePath;
  final VoidCallback? onDeleted; // optional callback to notify parent

  const ProductCard({
    super.key,
    required this.product,
    required this.imagePath,
    this.onDeleted,
  });

  Future<void> _handleDelete(BuildContext context) async {
    final repo = ProductRepository();
    final products = await repo.loadProducts();
    products.removeWhere(
      (p) =>
          p.productName == product.productName &&
          p.addedDate == product.addedDate,
    );
    await repo.saveProducts(products);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Product deleted")));
    onDeleted?.call();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final subtitle = product.isExpired
        ? "Expired"
        : "${product.daysLeft} days more";

    return Stack(
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
    );
  }
}
