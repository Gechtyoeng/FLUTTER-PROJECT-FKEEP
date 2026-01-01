import 'package:flutter/material.dart';
import '../../data/mock/mocks_data.dart'; 

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    final totalProducts = mockProducts.length;
    final totalEaten = mockHistory.fold<int>(0, (sum, h) => sum + h.totalEaten);
    final totalWasted = mockHistory.fold<int>(
      0,
      (sum, h) => sum + h.totalWasted,
    );

    // Filter nearly expired products (expireDate within 3 days)
    final nearlyExpire = mockProducts.where((p) {
      if (p.expireDate == null) return false;
      final daysLeft = p.expireDate!.difference(DateTime.now()).inDays;
      return daysLeft <= 3;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("FKEEP"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary section
            const Text(
              "All summaries",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _summaryCard(
                  "Total Products",
                  totalProducts.toString(),
                  Colors.blue,
                ),
                _summaryCard(
                  "Total Eaten",
                  totalEaten.toString(),
                  Colors.green,
                ),
                _summaryCard(
                  "Total Wasted",
                  totalWasted.toString(),
                  Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Nearly Expire section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Nearly Expire",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text("See All", style: TextStyle(color: Colors.blue)),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: nearlyExpire.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final product = nearlyExpire[index];
                  final daysLeft = product.expireDate != null
                      ? product.expireDate!.difference(DateTime.now()).inDays
                      : 0;
                  return _productCard(
                    product.productName,
                    "$daysLeft days more",
                    "${product.qty}${product.unit.name}",
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.kitchen),
            label: "My Fridge",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Products"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Shopping",
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _productCard(String name, String subtitle, String qty) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.fastfood, size: 40, color: Colors.orange),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Text(qty, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
