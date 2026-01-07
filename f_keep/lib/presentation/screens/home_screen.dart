import 'package:flutter/material.dart';
import '../../data/repositories/product_repo.dart';
import '../../models/product_model.dart';
import '../widgets/summary_card.dart';
import '../widgets/product_card.dart';
import '../screens/product_screen.dart';
import '../../data/services/product_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ProductService productService;
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    productService = ProductService(repository: ProductRepository());
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final loaded = await productService.loadProducts();
    setState(() {
      _products = loaded;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final totalProducts = productService.countByStatus(_products, ProductStatus.inFridge);
    final totalEaten = productService.countByStatus(_products, ProductStatus.eaten);
    final totalWasted = productService.countByStatus(_products, ProductStatus.wasted);
    final nearlyExpire = productService.getNearlyExpired(_products);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "FKEEP",
          style: TextStyle(color: scheme.onPrimary, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: scheme.primary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(25, 12, 25, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary section
                  const Text("All summaries", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: SummaryCard(title: "Total Products", value: totalProducts.toString(), color: Colors.blue, icon: Icons.shopping_basket),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: SummaryCard(title: "Total Eaten", value: totalEaten.toString(), color: Colors.green, icon: Icons.restaurant),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: SummaryCard(title: "Total Wasted", value: totalWasted.toString(), color: Colors.red, icon: Icons.delete),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Nearly Expire section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Nearly Expire", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductScreen()));
                        },
                        child: Text("See All", style: TextStyle(color: scheme.primary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 180,
                    child: nearlyExpire.isEmpty
                        ? const Center(child: Text("No products nearly expired"))
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: nearlyExpire.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final product = nearlyExpire[index];
                              final imagePath = productService.imageForCategory(product.category);

                              return SizedBox(
                                width: 160,
                                child: ProductCard(
                                  product: product,
                                  imagePath: imagePath,
                                  onDeleted: () async {
                                    final updated = await productService.deleteProduct(_products, product);
                                    setState(() => _products = updated);
                                  },
                                ),
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
