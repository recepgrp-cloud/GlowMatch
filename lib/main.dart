import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const GlowMatchApp());
}

class GlowMatchApp extends StatelessWidget {
  const GlowMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GlowMatch',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}