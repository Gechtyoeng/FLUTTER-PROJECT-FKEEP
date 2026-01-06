import 'package:flutter/material.dart';
import '../../data/repositories/product_repo.dart';
import '../screens/product_form.dart';
import '../../models/product_model.dart';
import '../../presentation/widgets/share_widget.dart';
import '../../presentation/widgets/product_card.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductRepository _repository = ProductRepository();
  List<Product> _products = [];
  bool _isLoading = true;
  Category? selectedCategory;

  static const Map<Category, String> _categoryImages = {
    Category.meat: 'assets/images/Meat.jpg',
    Category.vegetable: 'assets/images/Vegetable.jpg',
    Category.fruit: 'assets/images/Fruit.jpg',
    Category.other: 'assets/images/Fruit.jpg',
  };

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final loaded = await _repository.loadProducts();
    setState(() {
      _products = loaded;
      _isLoading = false;
    });
  }

  Future<void> _saveProducts() async {
    await _repository.saveProducts(_products);
  }

  Future<void> onEdit(Product product) async {
    final Product? updatedProduct = await Navigator.of(context).push<Product>(
      MaterialPageRoute(builder: (_) => ProductForm(product: product)),
    );
    if (updatedProduct != null) {
      setState(() {
        final index = _products.indexWhere(
          (p) => p.productId == product.productId,
        );
        if (index != -1) {
          _products[index] = updatedProduct;
        }
      });
      await _repository.saveProducts(_products);
    }
  }

  void onCreate() async {
    final Product? newProduct = await Navigator.of(context).push<Product>(
      MaterialPageRoute(builder: (context) => const ProductForm()),
    );
    if (newProduct != null) {
      setState(() {
        _products.add(newProduct);
      });
      await _saveProducts();
    }
  }

  void onDelete(int index) async {
    setState(() {
      _products.removeAt(index);
    });
    if (_products.isEmpty) {
      await _repository.clearProducts();
    } else {
      await _saveProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final filteredProducts = selectedCategory == null
        ? _products
        : _products.where((p) => p.category == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Products",
          style: TextStyle(
            color: scheme.onPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
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
              style: IconButton.styleFrom(
                backgroundColor: scheme.onPrimary,
                shape: const CircleBorder(),
              ),
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
                  // Filter Category
                  const Text(
                    "All Categories",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      FilterButton(
                        buttonText: "All",
                        isSelected: selectedCategory == null,
                        onTap: () => setState(() => selectedCategory = null),
                      ),
                      const SizedBox(width: 8),
                      FilterButton(
                        buttonText: "Meat",
                        isSelected: selectedCategory == Category.meat,
                        onTap: () =>
                            setState(() => selectedCategory = Category.meat),
                      ),
                      const SizedBox(width: 8),
                      FilterButton(
                        buttonText: "Vegetable",
                        isSelected: selectedCategory == Category.vegetable,
                        onTap: () => setState(
                          () => selectedCategory = Category.vegetable,
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilterButton(
                        buttonText: "Fruit",
                        isSelected: selectedCategory == Category.fruit,
                        onTap: () =>
                            setState(() => selectedCategory = Category.fruit),
                      ),
                      const SizedBox(width: 8),
                      FilterButton(
                        buttonText: "Other",
                        isSelected: selectedCategory == Category.other,
                        onTap: () =>
                            setState(() => selectedCategory = Category.other),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Product list
                  const Text(
                    "Products",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 180,
                    child: filteredProducts.isEmpty
                        ? const Center(child: Text('No products yet'))
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: filteredProducts.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];
                              final imagePath =
                                  _categoryImages[product.category] ??
                                  'assets/images/Fruit.jpg';

                              return SizedBox(
                                width: 160,
                                child: GestureDetector(
                                  onTap: () => onEdit(
                                    product,
                                  ), // <-- call the top function
                                  child: ProductCard(
                                    product: product,
                                    imagePath: imagePath,
                                    onDeleted: () async {
                                      setState(() {
                                        _products.removeWhere(
                                          (p) =>
                                              p.productId == product.productId,
                                        );
                                      });
                                      await _repository.saveProducts(_products);
                                    },
                                  ),
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
