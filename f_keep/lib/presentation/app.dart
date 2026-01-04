import 'package:flutter/material.dart';
import 'theme/fkeep_theme.dart';
import '../core/routes/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: fKeepRouter,
      debugShowCheckedModeBanner: false,
      title: 'FKEEP',
      theme: ThemeData(useMaterial3: true, colorScheme: appColor, scaffoldBackgroundColor: appColor.surface),
    );
  }
}
