library fui_kit;

import 'package:flutter/material.dart';

/// Import the package fui_kit
import 'package:fui_kit/fui_kit.dart';

void main() {
  runApp(const MyApp());
}

/// This Widget is the main application widget example.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fui Kit Example'),
        ),
        body: Center(
          child: IconButton(
            onPressed: () {},
            icon: const FUI(BoldRounded.ADD),
          ),
        ),
      ),
    );
  }
}
