import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes/app_router.dart';

class Navigationbar extends StatelessWidget {
  final int currentIndex;
  const Navigationbar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == currentIndex) return;

        switch (index) {
          case 0:
            context.goNamed(AppRoutes.home);
            break;
          case 1:
            context.goNamed(AppRoutes.products);
            break;
          case 2:
            context.goNamed(AppRoutes.shopping);
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.kitchen), label: "My Fridge"),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: "Products"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Shopping"),
      ],
    );
  }
}
