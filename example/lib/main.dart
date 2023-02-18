import 'package:flutter/material.dart';
import 'package:fui_kit/fui_kit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
            icon: FUI(
                file: FUIcons.regularRounded.commentAlt, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
