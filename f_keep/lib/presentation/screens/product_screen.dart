import 'package:flutter/material.dart';
import '../../data/repositories/product_repo.dart';
import '../screens/product_form.dart';
import '../../models/product_model.dart';
import '../../presentation/widgets/product_card.dart';
import '../../presentation/widgets/share_widget.dart';
import '../../data/services/product_service.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late final ProductService productService;
  final ProductRepository _productRepo = ProductRepository();
  List<Product> _products = [];
  bool _isLoading = true;

  Category? selectedCategory;
  ProductStatus? selectedStatus;

  static const Map<Category, String> _categoryImages = {
    Category.meat: 'assets/images/Meat.jpg',
    Category.vegetable: 'assets/images/Vegetable.jpg',
    Category.fruit: 'assets/images/Fruit.jpg',
    Category.other: 'assets/images/Fruit.jpg',
  };

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

  void onCreate() async {
    final Product? newProduct = await Navigator.of(context).push<Product>(MaterialPageRoute(builder: (context) => const ProductForm()));
    if (newProduct != null) {
      final updated = await productService.addProduct(_products, newProduct);
      setState(() => _products = updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final filteredProducts = _products
        .where((p) => (selectedStatus ?? ProductStatus.inFridge) == p.computedStatus)
        .where((p) => selectedCategory == null || p.category == selectedCategory)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Products",
          style: TextStyle(color: scheme.onPrimary, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: scheme.primary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton.filled(
              color: Colors.white,
              onPressed: onCreate,
              icon: Icon(Icons.add, color: scheme.primary),
              style: IconButton.styleFrom(backgroundColor: scheme.onPrimary, shape: const CircleBorder()),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Filter by Category", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            AppDropdown<Category?>(
                              value: selectedCategory,
                              items: [null, ...Category.values],
                              hintText: "Select Category",
                              onChanged: (val) => setState(() => selectedCategory = val),
                              labelBuilder: (c) => c == null ? "All" : c.name,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Filter by Status", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            AppDropdown<ProductStatus?>(
                              value: selectedStatus,
                              items: [null, ...ProductStatus.values],
                              hintText: "Select Status",
                              onChanged: (val) => setState(() => selectedStatus = val),
                              labelBuilder: (s) => s == null ? "All" : s.name,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  //List of Product
                  const Text("Products", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 180,
                    child: filteredProducts.isEmpty
                        ? const Center(child: Text('No products found'))
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: filteredProducts.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];
                              final imagePath = _categoryImages[product.category] ?? 'assets/images/Fruit.jpg';

                              return SizedBox(
                                width: 160,
                                child: ProductCard(
                                  product: product,
                                  imagePath: imagePath,
                                  onDeleted: () async {
                                    setState(() {
                                      _products.removeWhere((p) => p.productId == product.productId);
                                    });
                                    await _productRepo.saveProducts(_products);
                                  },
                                  onUpdated: (updatedProduct) async {
                                    setState(() {
                                      final idx = _products.indexWhere((p) => p.productId == updatedProduct.productId);
                                      if (idx != -1) {
                                        _products[idx] = updatedProduct;
                                      }
                                    });
                                    await _productRepo.saveProducts(_products);
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
