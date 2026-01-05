import 'package:go_router/go_router.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/product_screen.dart';
import '../../presentation/screens/shopping_screen.dart';
import 'package:flutter/material.dart';
import '../../presentation/widgets/navigation_bar.dart';

class AppRoutes {
  static const home = 'home';
  static const products = 'products';
  static const shopping = 'shopping';
}

final GoRouter fKeepRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        final location = state.matchedLocation;
        int currentIndex = 0;
        if (location.startsWith('/products')) currentIndex = 1;
        if (location.startsWith('/shopping')) currentIndex = 2;
        return Scaffold(
          body: child,
          bottomNavigationBar: Navigationbar(currentIndex: currentIndex),
        );
      },
      routes: [
        GoRoute(path: '/home', name: AppRoutes.home, builder: (context, state) => const HomeScreen()),
        GoRoute(path: '/products', name: AppRoutes.products, builder: (context, state) => const ProductScreen()),
        GoRoute(path: '/shopping', name: AppRoutes.shopping, builder: (context, state) => const ShoppingScreen()),
      ],
    ),
  ],
);
