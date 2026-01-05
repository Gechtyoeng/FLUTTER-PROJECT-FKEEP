import 'package:flutter/material.dart';
import '../screens/product_form.dart';
import '../../presentation/widgets/product_card.dart';
import '../../data/mock/mocks_data.dart';
import '../../models/product_model.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  void onCreate() async {
    Product? newProduct = await Navigator.of(context).push<Product>(MaterialPageRoute(builder: (context) => const ProductForm()));

    if (newProduct != null) {
      setState(() {
        mockProducts.add(newProduct);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton.filled(
              color: Colors.white,
              onPressed: onCreate,
              icon: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
              style: IconButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.onPrimary, shape: const CircleBorder()),
            ),
          ),
        ],
      ),
      body: Row(
        children: [...mockProducts.map((e) => ProductCard(name: e.productName, subtitle: e.productName, qty: e.qty.toString()))],
      ),
    );
  }
}
