import 'package:flutter/material.dart';
import 'views/home_scanner_view.dart'; // Add this import statement

void main() {
  runApp(const CaloricityApp());
}

class CaloricityApp extends StatelessWidget {
  const CaloricityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caloricity',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const HomeScannerView(), // Redirect configuration matrix to the Scanner Dashboard
    );
  }
}