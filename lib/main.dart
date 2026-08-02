import 'package:flutter/material.dart';

void main() {
  runApp(const SuperBurgerApp());
}

class SuperBurgerApp extends StatelessWidget {
  const SuperBurgerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Super Burger POS',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Burger POS 🍔'),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 80, color: Colors.orange),
            SizedBox(height: 16),
            Text(
              'مرحباً بك في نظام كاشير سوبر برجر',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
