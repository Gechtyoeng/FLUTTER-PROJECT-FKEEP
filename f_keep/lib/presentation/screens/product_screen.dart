import 'package:flutter/material.dart';
import '../widgets/navigation_bar.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product"), centerTitle: true, backgroundColor: Theme.of(context).colorScheme.primary),
      body: Center(child: Text('this is product screen')),
      bottomNavigationBar: Navigationbar(currentIndex: 1),
    );
  }
}
