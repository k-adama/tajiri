import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class DepositAddClientScreen extends StatefulWidget {
  const DepositAddClientScreen({super.key});

  @override
  State<DepositAddClientScreen> createState() => _DepositAddClientScreenState();
}

class _DepositAddClientScreenState extends State<DepositAddClientScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Nouveau Client",
          style: Style.interBold(),
        ),
      ),
      body: const Center(
        child: Text("Nouveau Client"),
      ),
    );
  }
}
