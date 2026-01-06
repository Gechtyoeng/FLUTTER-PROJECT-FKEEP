// import 'package:flutter/material.dart';
// import '../../data/repositories/product_repo.dart';
// import '../../models/product_model.dart';
// import '../widgets/summary_card.dart';
// import '../widgets/product_card.dart';
// import '../screens/product_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final ProductRepository _repository = ProductRepository();
//   List<Product> _products = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadProducts();
//   }

//   Future<void> _loadProducts() async {
//     final loaded = await _repository.loadProducts();
//     setState(() {
//       _products = loaded;
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final scheme = Theme.of(context).colorScheme;

//     final totalProducts = _products.length;
//     final totalEaten = _products
//         .where((p) => p.status == ProductStatus.eaten)
//         .length;
//     final totalWasted = _products
//         .where((p) => p.status == ProductStatus.wasted)
//         .length;

//     final nearlyExpire = _products.where((p) {
//       if (p.expireDate == null) return false;
//       final daysLeft = p.expireDate!.difference(DateTime.now()).inDays;
//       return daysLeft <= 3;
//     }).toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "FKEEP",
//           style: TextStyle(
//             color: scheme.onPrimary,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: scheme.primary,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Summary Card
//                   const Text(
//                     "All summaries",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 12),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Expanded(
//                         child: SummaryCard(
//                           title: "Total Products",
//                           value: totalProducts.toString(),
//                           color: Colors.blue,
//                           icon: Icons.shopping_basket,
//                         ),
//                       ),
//                       const SizedBox(width: 42),
//                       Expanded(
//                         child: SummaryCard(
//                           title: "Total Eaten",
//                           value: totalEaten.toString(),
//                           color: Colors.green,
//                           icon: Icons.restaurant,
//                         ),
//                       ),
//                       const SizedBox(width: 42),
//                       Expanded(
//                         child: SummaryCard(
//                           title: "Total Wasted",
//                           value: totalWasted.toString(),
//                           color: Colors.red,
//                           icon: Icons.delete,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 42),

//                   // Nearly Expire
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         "Nearly Expire",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => const ProductScreen(),
//                             ),
//                           );
//                         },
//                         child: const Text(
//                           "See All",
//                           style: TextStyle(color: Colors.blue),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   SizedBox(
//                     height: 180,
//                     child: nearlyExpire.isEmpty
//                         ? const Center(
//                             child: Text("No products nearly expired"),
//                           )
//                         : ListView.separated(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: nearlyExpire.length,
//                             separatorBuilder: (_, __) =>
//                                 const SizedBox(width: 12),
//                             itemBuilder: (context, index) {
//                               final product = nearlyExpire[index];
//                               final daysLeft = product.expireDate != null
//                                   ? product.expireDate!
//                                         .difference(DateTime.now())
//                                         .inDays
//                                   : 0;

//                               String imagePath;
//                               switch (product.category) {
//                                 case Category.meat:
//                                   imagePath = "assets/images/Meat.jpg";
//                                   break;
//                                 case Category.vegetable:
//                                   imagePath = "assets/images/Vegetable.jpg";
//                                   break;
//                                 case Category.fruit:
//                                   imagePath = "assets/images/Fruit.jpg";
//                                   break;
//                                 default:
//                                   imagePath = "assets/images/Fruit.jpg";
//                               }

//                               return SizedBox(
//                                 width: 160,
//                                 child: ProductCard(
//                                   product: product,
//                                   imagePath: imagePath,
//                                   onDeleted: () {
//                                     setState(() {
//                                       _products.removeAt(index);
//                                     });
//                                   },
//                                 ),
//                               );
//                             },
//                           ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../data/repositories/product_repo.dart';
import '../../models/product_model.dart';
import '../widgets/summary_card.dart';
import '../widgets/product_card.dart';
import '../screens/product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductRepository _repository = ProductRepository();
  List<Product> _products = [];
  bool _isLoading = true;

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

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // Summaries using computedStatus
    final totalProducts = _products
        .where((p) => p.computedStatus == ProductStatus.inFridge)
        .length;

    final totalEaten = _products
        .where((p) => p.computedStatus == ProductStatus.eaten)
        .length;

    final totalWasted = _products
        .where((p) => p.computedStatus == ProductStatus.wasted)
        .length;

    // Nearly expire: only inFridge and <= 3 days left
    final nearlyExpire = _products.where((p) {
      if (p.expireDate == null) return false;
      final daysLeft = p.expireDate!.difference(DateTime.now()).inDays;
      return daysLeft <= 3 && p.computedStatus == ProductStatus.inFridge;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "FKEEP",
          style: TextStyle(
            color: scheme.onPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: scheme.primary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: SummaryCard(
                          title: "Total Products",
                          value: totalProducts.toString(),
                          color: Colors.blue,
                          icon: Icons.shopping_basket,
                        ),
                      ),
                      const SizedBox(width: 42),
                      Expanded(
                        child: SummaryCard(
                          title: "Total Eaten",
                          value: totalEaten.toString(),
                          color: Colors.green,
                          icon: Icons.restaurant,
                        ),
                      ),
                      const SizedBox(width: 42),
                      Expanded(
                        child: SummaryCard(
                          title: "Total Wasted",
                          value: totalWasted.toString(),
                          color: Colors.red,
                          icon: Icons.delete,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 42),

                  // Nearly Expire section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Nearly Expire",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProductScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "See All",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 180,
                    child: nearlyExpire.isEmpty
                        ? const Center(
                            child: Text("No products nearly expired"),
                          )
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: nearlyExpire.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final product = nearlyExpire[index];
                              final daysLeft = product.daysLeft;

                              String imagePath;
                              switch (product.category) {
                                case Category.meat:
                                  imagePath = "assets/images/Meat.jpg";
                                  break;
                                case Category.vegetable:
                                  imagePath = "assets/images/Vegetable.jpg";
                                  break;
                                case Category.fruit:
                                  imagePath = "assets/images/Fruit.jpg";
                                  break;
                                default:
                                  imagePath = "assets/images/Fruit.jpg";
                              }

                              return SizedBox(
                                width: 160,
                                child: ProductCard(
                                  product: product,
                                  imagePath: imagePath,
                                  onDeleted: () async {
                                    setState(() {
                                      _products.removeWhere(
                                        (p) => p.productId == product.productId,
                                      );
                                    });
                                    await _repository.saveProducts(_products);
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
