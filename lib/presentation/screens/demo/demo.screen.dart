import 'package:flutter/material.dart';

class DemoAppScreen extends StatefulWidget {
  const DemoAppScreen({super.key});

  @override
  State<DemoAppScreen> createState() => _DemoAppScreenState();
}

class _DemoAppScreenState extends State<DemoAppScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Page demo"),
      ),
    );
  }
}
