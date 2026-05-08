import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Care',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pet Care'),
          backgroundColor: Colors.green,
        ),
        body: const Center(
          child: Text(
            'Hello Pet Care!',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}