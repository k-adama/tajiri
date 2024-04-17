import 'package:flutter/material.dart';

class BluetoothHeaderComponent extends StatelessWidget {
  final String title;
  final TextStyle style;
  const BluetoothHeaderComponent({
    super.key,
    required this.title,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Text(
          title,
          style: style,
        ),
      ),
    );
  }
}
