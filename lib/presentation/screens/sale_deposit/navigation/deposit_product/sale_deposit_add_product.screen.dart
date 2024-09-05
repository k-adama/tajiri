import 'package:flutter/material.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';

class SaleDepositAddProductScreen extends StatefulWidget {
  const SaleDepositAddProductScreen({super.key});

  @override
  State<SaleDepositAddProductScreen> createState() =>
      _SaleDepositAddProductScreenState();
}

class _SaleDepositAddProductScreenState
    extends State<SaleDepositAddProductScreen> {
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
