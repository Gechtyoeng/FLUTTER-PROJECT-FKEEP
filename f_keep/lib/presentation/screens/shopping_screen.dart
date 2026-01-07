import 'package:f_keep/data/services/shopping_prediction_service.dart';
import 'package:f_keep/data/services/shopping_service.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/product_history_repo.dart';
import '../../data/repositories/product_repo.dart';
import '../../data/repositories/shopping_repo.dart';
import '../../models/shopping_list_model.dart';
import '../widgets/share_widget.dart';
import '../screens/shopping_list_detail.dart';
import '../widgets/add_shopping_list.dart';
import '../../data/services/shopping_generation_service.dart';
import '../widgets/empty_state.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  late final ShoppingService shoppingService;
  List<ShoppingList> shoppingLists = [];

  ShoppingStatus _currentFilter = ShoppingStatus.progress;

  //function for filter the shopping list
  List<ShoppingList> get filteredLists {
    return shoppingLists.where((list) => list.status == _currentFilter).toList();
  }

  @override
  void initState() {
    super.initState();
    shoppingService = ShoppingService(
      productRepo: ProductRepository(),
      historyRepo: ProductHistoryRepository(),
      shoppingRepo: ShoppingRepository(),
      generationService: ShoppingGenerationService(predictionService: ShoppingPredictionService()),
    );
    _loadLists();
  }

  Future<void> _loadLists() async {
    final lists = await shoppingService.loadLists();
    print("Loaded lists: ${lists.length}");
    setState(() => shoppingLists = lists);
  }

  Future<void> _addList(ShoppingList newList) async {
    await shoppingService.addList(newList);
    setState(() {
      shoppingLists.add(newList);
      _currentFilter = ShoppingStatus.pending;
    });
  }

  //generate the shopping list
  Future<void> _generateSmartShoppingList() async {
    final shoppingList = await shoppingService.generateSmartShoppingList();
    // save the new shopping list
    print("Generated shopping list: ${shoppingList.toJson()}");
    _addList(shoppingList);
  }

  void onCreate() async {
    final newShoppingList = await showModalBottomSheet<ShoppingList>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return FractionallySizedBox(heightFactor: 0.6, child: AddShoppingListBottomsheet());
      },
    );

    if (newShoppingList != null) {
      _addList(newShoppingList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Shopping",
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 12, 25, 12),
        child: Column(
          children: [
            InkWell(
              onTap: _generateSmartShoppingList,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 50,
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star_border, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 12),
                    const Text('Generate shopping List', style: TextStyle(fontWeight: FontWeight.normal)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Shopping List', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      for (final status in ShoppingStatus.values) ...[
                        FilterButton(buttonText: status.name, isSelected: _currentFilter == status, onTap: () => setState(() => _currentFilter = status)),
                        const SizedBox(width: 12),
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: filteredLists.isEmpty
                        ? EmptyState(title: 'No shopping list', icon: Icons.shopping_bag)
                        : ListView.builder(
                            itemCount: filteredLists.length,
                            itemBuilder: (context, index) {
                              final list = filteredLists[index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 8),
                                child: ShoppingListTile(
                                  shoppingList: list,
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ShoppingListDetail(shoppingList: list))),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShoppingListTile extends StatelessWidget {
  final ShoppingList shoppingList;
  final VoidCallback onTap;
  const ShoppingListTile({super.key, required this.shoppingList, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          title: Text(shoppingList.title ?? 'shoppingList', style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onPrimary)),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary, borderRadius: BorderRadius.circular(4)),
            child: Text(shoppingList.status.name, style: const TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ),
      ),
    );
  }
}
