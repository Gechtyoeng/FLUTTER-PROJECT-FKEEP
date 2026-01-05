import 'package:go_router/go_router.dart';
import '../../models/product_model.dart';
import '../../models/shopping_list_model.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/product_screen.dart';
import '../../presentation/screens/shopping_screen.dart';
import '../../presentation/screens/product_form.dart';
import '../../presentation/screens/shopping_list_detail.dart';
import '../../presentation/screens/product_detail.dart';

class AppRoutes {
  static const home = 'home';
  static const products = 'products';
  static const shopping = 'shopping';

  static const productForm = 'product-form';
  static const productDetail = 'product-detail';
  static const shoppingListDetail = 'shopping-list-detail';
}

final GoRouter fKeepRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      name: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/products',
      name: AppRoutes.products,
      builder: (context, state) => const ProductScreen(),
    ),
    GoRoute(
      path: '/shopping',
      name: AppRoutes.shopping,
      builder: (context, state) => const ShoppingScreen(),
    ),
    // screen that do not need the bottom navigation bar
    GoRoute(
      path: '/product-form',
      name: AppRoutes.productForm,
      builder: (context, state) {
        final product = state.extra is Product ? state.extra as Product : null;
        return ProductForm(product: product);
      },
    ),
    GoRoute(
      path: '/product-detail',
      name: AppRoutes.productDetail,
      builder: (context, state) {
        final product = state.extra as Product;
        return ProductDetail(product: product);
      },
    ),
    GoRoute(
      path: '/shopping-list-detail',
      name: AppRoutes.shoppingListDetail,
      builder: (context, state) {
        final shoppingList = state.extra as ShoppingList;
        return ShoppingListDetail(shoppingList: shoppingList);
      },
    ),
  ],
);
