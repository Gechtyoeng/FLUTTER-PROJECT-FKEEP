import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final IconData? icon;
  const EmptyState({super.key, required this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[Icon(icon, size: 64, color: scheme.primary), const SizedBox(height: 16)],
          Text(title, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
