import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'pages/product_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider()..loadCart(),
      child: const VioCartApp(),
    ),
  );
}

class VioCartApp extends StatelessWidget {
  const VioCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VioCart',

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F5FF),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B5CF6),
        ),

        fontFamily: 'Poppins',
      ),

      home: const ProductPage(),
    );
  }
}