import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/fkeep_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FKEEP',
      theme: ThemeData(useMaterial3: true, colorScheme: appColor, scaffoldBackgroundColor: appColor.surface),
      home: const HomeScreen(),
    );
  }
}
