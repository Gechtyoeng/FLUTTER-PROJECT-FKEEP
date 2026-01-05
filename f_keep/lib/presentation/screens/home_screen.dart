import 'package:f_keep/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import '../../data/mock/mocks_data.dart';
import '../widgets/summary_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final totalProducts = mockProducts.length;
    final totalEaten = mockHistory.fold<int>(0, (sum, h) => sum + h.totalEaten);
    final totalWasted = mockHistory.fold<int>(0, (sum, h) => sum + h.totalWasted);
    final nearlyExpire = mockProducts.where((p) {
      if (p.expireDate == null) return false;
      final daysLeft = p.expireDate!.difference(DateTime.now()).inDays;
      return daysLeft <= 3;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "FKEEP",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary section
            const Text("All summaries", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: SummaryCard(title: "Total Products", value: totalProducts.toString(), color: Colors.blue, icon: Icons.shopping_basket),
                ),
                SizedBox(width: 42),
                Expanded(
                  child: SummaryCard(title: "Total Eaten", value: totalEaten.toString(), color: Colors.green, icon: Icons.restaurant),
                ),
                SizedBox(width: 42),
                Expanded(
                  child: SummaryCard(title: "Total Wasted", value: totalWasted.toString(), color: Colors.red, icon: Icons.delete),
                ),
              ],
            ),
            const SizedBox(height: 42),

            // Nearly Expire section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Nearly Expire", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  final daysLeft = product.expireDate != null ? product.expireDate!.difference(DateTime.now()).inDays : 0;
                  return ProductCard(
                    name: product.productName,
                    subtitle: "$daysLeft days more",
                    qty: "${product.qty}${product.unit.name}",
                    icon: Icons.fastfood,
                    color: Colors.orange,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
