import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class DepositAddProductScreen extends StatefulWidget {
  const DepositAddProductScreen({super.key});

  @override
  State<DepositAddProductScreen> createState() =>
      _DepositAddProductScreenState();
}

class _DepositAddProductScreenState extends State<DepositAddProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Nouveau Produit",
          style: Style.interBold(),
        ),
      ),
      body: Container(
        child: Center(
          child: Text("Nouveau Produit"),
        ),
      ),
    );
  }
}
